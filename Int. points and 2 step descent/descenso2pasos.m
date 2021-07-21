function [W, H] = descenso2pasos(X, k)
%Metodo de descenso en dos pasos o descenso por coordenadas para
%factorización no negativa de una matriz
% Min   ||X - W*H ||_F^2
% s.a.   W >= 0
%        H >= 0
%
% Input
% X matriz real de rxp con entradas positivas
% k iteraciones del metodo, es mucho menor que r y que p
%
%Output
% W matriz de rxk con entradas positivas
% H matriz de kxp con entradas positivas
% W*H aproxima la matriz X
%
%--------------------------------------------------------------------------
% Optimización Numérica
% Proyecto 1
% 08 de octubre del 2020
% Luis Guillermo Pizana
% Sofía De la Mora
%--------------------------------------------------------------------------
% Parametros iniciales
[r,p] = size(X);    
W = zeros(r,k)+1/2;      
H = ones(k,p);
maxiter=k;
citer=0;
W_prev = zeros(r,k);%matrix para guardar la iteracion anterior     
H_prev = zeros(k,p);%matrix para guardar la iteracion anterior
tol=1e-08; %tolerancia para las condiciones de paro
norma = norm(W - W_prev,'fro') + norm(H - H_prev,'fro');%para condición de paro
%--------------------------------------------------------------------------
while(norma > tol && citer < maxiter) %todos iteran hasta maxiter (k)en el payaso
    
    H_prev = H;
    W_prev = W;
    
    %Calcula H fijando W
    bh = zeros(k,1);
    Ah = eye(k);
    Qh= W'*W;
    for j = 1:p   
        ch = (-X(:, j)'*W)';
        [xh,~,~] = punintpc(Qh, Ah, ch, bh);
        %xh=quadprog(Qh,ch,-Ah,-bh);
        H(:,j) = xh; 

    end
    
    % Calcula W fijando H
    Qw= H*H';
    bw = zeros(k,1);
    Aw = eye(k);
    for l = 1:r
        cw = (-X(l, :)*H')';   
        [xw,~,~] = punintpc(Qw, Aw, cw, bw);
        %xw=quadprog(Qw,cw,-Aw,-bw);
        W(l,:)= xw';
    end
    norma = norm(W - W_prev,'fro') + norm(H - H_prev,'fro');
    citer=citer+1;
end 
