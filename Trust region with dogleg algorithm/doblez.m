function [ps] = doblez(B,g,Delta)
% Técnica del doblez (dogleg) para resolución del problema cuadrático de región de
% confianza
% Min (1/2)*p'*B*p + g'*p + f(x)
% sa ||p|| <= Delta
%B matriz hessiana
%g vector gradiente

pN = -g'/B;  %Dirección de Newton   (resuelve el problema de la forma
             % xA = B
pN = pN';
pC = - ((g'*g)/(g'*B*g))*g; %Dirección de Cauchy
if norm(pN) <= Delta %si el optimo (form. cuadrática)esta en el radio
    ps = pN; 
else
    if norm(pC) >= Delta    %Punto de cauchy: Max descenso en dirección del
                            %gradiente
        ps = (Delta/norm(pC))*pC;
    else
        %ecuación de segundo grado
        % ||pC+t(pN-pC)||^2 - Delta^2 = 0
        % (pC+t*u)'(pC+t*u) - (Delta^2) = 0
        % a(coef)*t*t+b(coef)*t+c(indep) = 0
        u = pN-pC;   %Dirección hacia pN de pC.
        a = u'*u; b = 2*pC'*u; c = pC'*pC - Delta^2;  %Este en el circulo
        t = roots([a b c]);
        if t(1) > 0
            ts = t(1);
        else
            ts = t(2);
        end
        ps = pC + ts*u;
    end
end
end

  
        
        
        
