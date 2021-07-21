function [x, lambda, k] = pcsglobal(fx, hx, x0)
% Metodo de programacion Cuadratica Sucesiva con busqueda de lineal,
% usando la funcion de merito L-1 y actualizacion de la hessiana
% con la formula BF GS para el problema
% Min fx
% Sujeto a hx = 0
%
% fx y hx son cadenas de caracteres con las funciones en Matlab
% de la funcion objetivo y las restricciones del problema
% El vector x0 es el valor inicial
% Salida
% x.- aproximacion al minimo local
% lambda.- multiplicador de Lagrange asociado a x.
% k.- numero de iteraciones realizadas.
%
% Debe usar las funciones: gradiente.m y jacobiana.m para calcular
% las primeras derivadas.
%-----------------------------------------------------
%Luis Guillermo Pizana
%Sofia De la Mora 
%Optimizacion Numerica
%Proyecto 2
%05 noviembre 2020
%-----------------------------------------------------------------------
format long e
%Valores iniciales
n = length(x0);%Tomamos el tamaño del vector inicial para los calculos
hx_eval = feval(hx,x0); %Restricciones evaluadas en el punto inicial para 
%encontrar m
m = length(hx_eval);%Se calcula el tamaño de las restricciones ya evaluadas
k = 0; %Comenzamos el contador de iteraciones en cero
c_1 = 10^-02; %parametro para la búsqueda en línea
Ck = 1; %C_0 inicializada en 1 
Cmax = 10^5; %Parametro para limitar los cambios en la Ck
x = x0; %Rl vector x inicia en x_0 y continua con el nombre 'x'

lambda = zeros(m,1); % Multiplicador de Lagrange del problema
B = eye(n); %B_0 Hessiana con respecto a x del Lagrangeano inicializada 
%en la identidad de tamaño n
gf = gradiente(fx, x0); %gradiente de fx (la fn a minimizar) en el punto 
%inicial
Ak = jacobiana(hx, x0); %jacobiana de las restricciones en el punto inicial
%----------------------------------------------------------------------
%Valores de paro
tol=10^-05; %Tolerancia para parar el loop
maxk=100; %Iteraciones maximas para parar el loop
vk=[[gf + Ak'*lambda]'  hx_eval']; %Condiciones Necesarias de Primer Orden 
%cuya norma indicará al loop un paro
%----------------------------------------------------------------------
%Metodo
while ((norm(vk) >= tol) && (k < maxk))%Comienza el loop con las condiciones
    %que la norma de las CNPO sean mayores a la tolerancia y no se alcancen
    %las iteraciones maximas
    
    %Resuelve problema cuadratico
    W = [ B  Ak' ; Ak zeros(m)];  %Matriz del sistema lineal
    ld = -[gf; hx_eval]; %Lado derecho de la ecuacion
   
    sol = W\ld; %Buscamos la solucion del problema lineal multiplicando los
    %dos lados por la inversa de W que tiene siempre rango completo
    pk = sol(1:n); %Solución en la iteración k 
    lambda = sol(n+1:n+m);%Nuevo multiplicador de Lagrange (lambda k+1)

    %------------------------------------------------------------
    %Escoger (actualizar) Ck+1
    if gf'*pk-Ck*norm(hx_eval,1)>=0 %En otro caso continuamos con Ck+1=Ck
        Ck=min(Cmax, abs(gf'*pk)/norm(hx_eval,1)+1);   
    end
    
    %------------------------------------------------------------
    %Busqueda en linea
    alfak=1;%Iniciamos alfa que recortara el paso en uno.
    Dk= gradiente(fx,x)' * pk - Ck* norm(feval(hx,x),1); %Derivada direccional
    while ( merit_fn(fx,hx,x+alfak*pk,Ck) > merit_fn(fx,hx,x,Ck)+alfak*c_1*Dk) 
       alfak=alfak/2; %si se cumple que la funcion de merito en el punto 
       %siguiente es mayor que la misma funcion en el punto actual más la
       %derivada direccional 'cortada', entonces se recorta el paso a la
       %mitad
    end 
        %------------------------------------------------------------
    %Guardar parámetros de la iteración k para utilizarlos mas adelante
    Ck_ant=Ck;
    x_ant=x;
    h_ant = hx_eval;
    g_ant = gf;
    A_ant = Ak;
    lambda_ant = lambda;
    %------------------------------------------------------------
    %Actualizar los parametros ahora en la actualizacion k+1
    x = x + alfak*pk; %x_k+1
    s = x -x_ant; %s_k
    y = [gf + Ak'*lambda] - [gf + Ak'*lambda]; %y_k
    hx_eval = feval(hx,x); 
    %------------------------------------------------------------
    %------------------------------------------------------------
    %Actualizacion Hessiana con BFGS powell
    if s'*y <= 0.2*s'*B*s
       theta = (0.8*s'*B*s)/(s'*B*s -s'*y);
       r = y +theta*(B*s -y);
    else
       r = y;
    end
    
    B = B - (B*s*s'*B)/(s'*B*s) + (r*r')/(s'*r);
    
    if cond(B)> 10^4
        B=eye(n);
    end
   %------------------------------------------------------------
   %Nuevo multiplicador de Lagrange
    %Resolviendo min || gf_k+1 +A_k+1' * lambda||2
                %lambda en R^m
   %Solucion: lambda= -(A_k+1'*A_k+1)^-1*A_k+1*gf_k+1
   gf = gradiente(fx,x); %gradiente en k+1
   Ak = jacobiana(hx,x) ; %jacobiana en k+1
   lambda= -(Ak*Ak')\Ak*gf; %Nuevo multiplicador de lagrange solucionando 
   %el problema || gf_k+1 + Ak+1'*lambda ||_2
   %------------------------------------------------------------
   % Actualizar iteracion
   k=k+1; %Aumentamos un 1 al contador de iteraciones
   %------------------------------------------------------------
   % Actualizar vk
   vk=[[gf + Ak'*lambda]'  hx_eval']; %Actualiza las CNPO
end
disp(' iteraciones     Norma de las CNPO')
disp('-------------------------------------')
disp(sprintf(' %i      %3.16f',k, norm(vk)))
end
%------------------------------------------------------------

