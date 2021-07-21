function [f]= fesfera(x)
% Función de repulsión para (n/3) puntos en la esfera unitaria de dimensión
% tres.
% Codigo de clase
% Optimización Numérica
% Luis Guillermo Pizaña
% Sofia De la Mora
% Para 'esfera.m'

n = length(x);
np = floor(n/3); % número de puntos en la esfera
f = 0;           % valor incial de f

for i=1:np-1
    ui = x(3*(i-1)+1:3*i);        % anclados en el punto ui
    for j = i+1:np
        uj = x(3*(j-1)+1:3*j);    % punto uj
        f = f + (1/norm(ui-uj));    % la función crece en sumandos
    end
end

end