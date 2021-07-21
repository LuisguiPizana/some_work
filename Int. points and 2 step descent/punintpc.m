function [x, y, mu] = punintpc(Q, A, c, b)
% Resuelve el problema cuadratico por el metodo de punto interior
% Min   (1/2)* x' * Q * x + c'* x
% s.a.   A * x >= b
%
% Input:
%
% Q matriz de nxn simétrica y definida positiva
% A matriz de mxn de rango completo con n>=m
% c es vector columna real de tamaño n
% b es vector columna real de tamaño m
%
%Output:
%
% x vector real de tamaño n que aproxima la solucion del minimo local del
%problema
% y vector de tamaño m que contiene las variables de holgura del problema
% mu vector de tamaño m que contiene el multiplicador de lagrange de la
%restricción desigual
%
%Supuesto:
%
% Suponemos que el conjunto de vectores x en R^n con Ax>b es distinto al
% vacío
%
%--------------------------------------------------------------------------
% Optimización Numérica
% Proyecto 1
% 08 de octubre del 2020
% Luis Guillermo Pizana
% Sofía De la Mora
%--------------------------------------------------------------------------
% Parametros iniciales
format long
n = length(c);     % numero de variables a minimizar
m = length(b);     % numero de restricciones
maxiter = 100;     % iteraciones maximas
tol = 1e-06;      % tolerancia de CNPO 
citer = 0;         % contador iteraciones
%--------------------------------------------------------------------------
%Variables iniciales
x = ones(n,1); 
y = ones(m,1);
mu = ones(m,1);
e = ones(m,1);
sigma=0.5;
eta = sigma*(y'*mu)/m; %sigma*y'mu/m, con sigma en [0,1] tomamos 1/2.
%--------------------------------------------------------------------------
%Matrices iniciales
Y= diag(y);
Y_in=diag(1./y);
U= diag(mu);
%Y_in_U= (1./y).*mu;
%--------------------------------------------------------------------------
% Condiciones necesarias de primer orden (CNPO) para un minimo
H =[Q*x - A'*mu+c; A*x- y - b; Y*U*e];
norma = norm(H, 'fro'); %Norma de CNPO
while(norma > tol && citer < maxiter)% Iteraciones método de Newton
    
    % Resuelve el sistema lineal de Newton para la trayectoria central 
    r_x=Q*x-A'*mu+c; 
    r_y=A*x-y-b;     
    r_mu=mu.*y-eta*e; 

    %Sistema a resolver
    D = Q+A'*Y_in*U*A;
    z = -(r_x+A'*Y_in*U*r_y+A'*Y_in*r_mu);
    
    %Pasos
    delta_x= D\z;
    delta_y=A*delta_x+r_y;
    delta_mu=-Y_in*(U*delta_y+r_mu);
    
    %Recorte de paso (codigo de clase)
    bt = []; gm = [];
    for k =1:m
        if(delta_mu(k) < 0)
            bt = [bt; -(mu(k)/delta_mu(k))];
        else
            bt= [bt; 1];
        end
        if (delta_y(k) < 0)
            gm = [gm; -(y(k)/delta_y(k))];
        else
            gm = [gm; 1];
        end
    end
    
    alpha = min([bt ; gm]);
    alpha =(0.9995)*min([1 alpha]);  
    
    % Actualizar puntos  
    x = x + alpha*delta_x;
    mu = mu + alpha*delta_mu;
    y = y + alpha*delta_y;
    % Actualizar matrices
    Y=diag(y);
    U=diag(mu);
    Y_in=diag(1./y); 
    
    %Actualizar eta con nuevas y y mu
    eta = sigma*(y'*mu)/m;

    %CNPO para minimo
    H =[Q*x - A'*mu+c; A*x- y - b; Y*U*e];    
    norma = norm(H, 'fro'); 
    citer = citer + 1; %contador porque tenemos limitante de iteraciones
end

end

