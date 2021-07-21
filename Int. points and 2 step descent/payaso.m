%Se resuelve el problema de descenso en dos pasos con diferentes valores
%para la imagen en grises del payaso
%--------------------------------------------------------------------------
% Optimización Numérica
% Proyecto 1
% 08 de octubre del 2020
% Luis Guillermo Pizana
% Sofía De la Mora
%--------------------------------------------------------------------------
clear all;
clc;
warning('off');
load clown; %Carga imagen con la que se trabaja
colormap('gray');%Pone la imagen del payaso en grises
image(X);
k = [5, 20, 30, 60, 80];
%--------------------------------------------------------------------------
%Para descenso2pasos. Descomentar lineas 37 y 48 de descenso2pasos y
%comentar las lineas 38 y 49
%Generamos las imagenes y las guardamos:
for i=1:length(k) %Calculamos para distintas k la factorizacion
    tic;
    [W, H] = descenso2pasos(X, k(i));
    toc;
    norma=norm(X-W*H,'fro');
    clown=image(W*H);%Genera la imagen
    saveas(clown,sprintf('Clown2p_k%d.png',k));%Guarda la imagen con el nombre "Clown2p_k#" con la k que se utiliza
    fprintf("\nNorma de la diferencia: %f\n", norma);
end
%--------------------------------------------------------------------------
%Para Quadprog. Descomentar lineas 38 y 49 de descenso2pasos y
%comentar las lineas 37 y 48
%Generamos las imagenes y las guardamos:
% for i=1:length(k) %Calculamos para distintas k la factorizacion
%     tic;
%     [W, H] = descenso2pasos(X, k(i));
%     toc;
%     norma= norm(X-W*H,'fro');
%     clown=image(W*H);%Genera la imagen
%     saveas(clown,sprintf('ClownQuad_k%d.png',k));%Guarda la imagen con el nombre "ClownQuad_k#" con la k que se utiliza
%     fprintf("\nNorma frobenius de la diferencia: %f\n", norma);
% end