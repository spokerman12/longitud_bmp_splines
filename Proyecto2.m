% Universidad Simon Bolivar
% CO3211 - Calculo Numerico
% Proyecto 2

% Fecha: 26.12.2018

% Daniel Francis
% 12-10863

% Se omiten intencionalmente
% los acentos en el comentario
% de este archivo.

1;
format long;

% 1.

function [S,a,b,c,d] = spline_cubico(x,y,deriv_a,deriv_b)
% Genera los coeficientes de los splines cubicos
% correspondientes a los puntos de interpolacion
% 'x' e 'y'.
% Si se suministran las derivadas de los limites de interpolacion
% se genera el spline amarrado.
% De lo contrario, debemos escribir "nada" como argumento.
  if deriv_a == "nada" && deriv_b == "nada"
    [S,a,b,c,d] = spline_natural(x,y);
  else
    [S,a,b,c,d] = spline_amarrado(x,y,deriv_a,deriv_b);  
  endif
  
endfunction

function [coefs,a,b,c,d] = spline_natural(x,y);
% Genera los coeficientes del spline natural
% a partir de los puntos 'x' e 'y'

  % Las coordenadas en el eje de las
  % abscisas deben ser diferentes
  % (no debe haber espaciacion igual a 0 entre dos puntos)
  x = unique(x);
  n = length(x);
  
  h = zeros(n-1,1);
  a = y;
  
  for i=1:n-1
    h(i) = x(i+1)-x(i);
  endfor
  
  A = zeros(n-1);
  
  for i=1:n-2
    A(i,i)   = h(i);
    A(i,i+1) = 2*(h(i)+h(i+1));
    A(i,i+2) = h(i+1);
  endfor
    
  B = zeros(n-1,1);

  for i=1:n-2
    B(i) = (3/h(i+1))*(a(i+2)-a(i+1)) - (3/h(i))*(a(i+1)-a(i));
  endfor
  
  B = [0;B];
  A = [zeros(1,n);A];
  A(1,1) = 1;
  A(n,n) = 1;
  
  c = A\B;
  
  b = zeros(n,1);
  d = b;
  
  for j=1:n-1
    b(j) = (a(j+1)-a(j))/h(j) - h(j)*(c(j+1)+2*c(j))/3;
    d(j) = (c(j+1)-c(j))/(3*h(j));
  endfor
  
  coefs = [a',b,c,d](1:n-1,:);
  a = coefs(:,1);
  b = coefs(:,2);
  c = coefs(:,3);
  d = coefs(:,4);
  
endfunction

function [coefs,a,b,c,d] = spline_amarrado(x,y,deriv_a,deriv_b);
% Genera los coeficientes del spline amarrado
% a partir de los puntos 'x' e 'y'

  % Las coordenadas en el eje de las
  % abscisas deben ser diferentes
  % (no debe haber espaciacion igual a 0 entre dos puntos)
  x = unique(x);
  n = length(x);
  
  h = zeros(n-1,1);
  a = y;
  
  for i=1:n-1
    h(i) = x(i+1)-x(i);
  endfor
  
  A = zeros(n-1);
  
  for i=1:n-2
    A(i,i)   = h(i);
    A(i,i+1) = 2*(h(i)+h(i+1));
    A(i,i+2) = h(i+1);
  endfor
    
  B = zeros(n-1,1);

  B = [0;B];
  B(1) = (3/h(1))*(a(2)-a(1))-(3*deriv_a);
  B(n) = 3*deriv_b - (3/h(n-1))*(a(n)-a(n-1));

  for i=2:n-1
    B(i) = (3/h(i))*(a(i+1)-a(i)) - (3/h(i-1))*(a(i)-a(i-1));
  endfor
  
  A = [zeros(1,n);A];
  A(1,1) = 2*h(1);
  A(1,2) = h(1);
  A(n,n) = 2*h(n-1);
  A(n,n-1) = h(n-1);

  c = A\B;
  
  b = zeros(n,1);
  d = b;
  
  for j=1:n-1
    b(j) = (a(j+1)-a(j))/h(j) - h(j)*(c(j+1)+2*c(j))/3;
    d(j) = (c(j+1)-c(j))/(3*h(j));
  endfor
  
  coefs = [a',b,c,d](1:n-1,:);
  a = coefs(:,1);
  b = coefs(:,2);
  c = coefs(:,3);
  d = coefs(:,4);
    
endfunction


%2. 

function s = longitud_arco(a,b,c,d,lim1,lim2)
% Calcula la longitud de arco de un polinomio
% de grado 3, definido en el intervalo [lim1,lim2]
  f = @(x) sqrt(1+(b+2.*c.*(x-lim1)+3*d .*(x-lim1) .^2).^ 2);
  s = quad(f,lim1,lim2);
endfunction

%3.

function [y] = horner(coefs,x,x_inf)
% Evalua al polinomio de grado 3  de coeficientes 'coefs'
% en el punto x, tomando en cuenta la traslacion de x_inf

% Se utiliza, en vez de la implementacion
% clasica del metodo iterativo de Horner,
% una formula cerrada, por ser mas sencilla 
% de manipular para la depuracion de errores
  y = coefs(1) + coefs(2)*(x-x_inf);
  y = y + coefs(3).*(x-x_inf).^2;
  y = y + coefs(4).*(x-x_inf).^3;

endfunction 

function [x,y] = captura_puntos_1
% Captura los puntos del mapa dispuesto en la
% direccion de archivo dada, los cuales
% corresponden a la mitad superior de la 
% Peninsula de Paraguana.

% Ajustar la ruta del archivo a conveniencia
  a=imread('C:\Users\andre\OneDrive\Documents\dani\calculo\paraguana_volteado_1.bmp'); 
  pixvert=size(a,1);
  pixhor=size(a,2);
  x = [];
  y = [];

  for i=1:pixhor
      for j=1:pixvert
          rojo = a(j,i,1);
          verde = a(j,i,2);
          azul = a(j,i,3);
          
         if (rojo == 255) && (verde == 0) && (azul == 0)
             x = [x i];
              y = [y pixvert-j];
          end
     end
  end
end


function [x,y] = captura_puntos_2
% Captura los puntos del mapa dispuesto en la
% direccion de archivo dada, los cuales
% corresponden a la mitad inferior de la 
% Peninsula de Paraguana.

% Ajustar la ruta del archivo a conveniencia
  a=imread('C:\Users\andre\OneDrive\Documents\dani\calculo\paraguana_volteado_2.bmp'); 
  pixvert=size(a,1);
  pixhor=size(a,2);
  x = [];
  y = [];
  for i=1:pixhor
      for j=1:pixvert
          rojo = a(j,i,1);
          verde = a(j,i,2);
          azul = a(j,i,3);
        
          if (rojo == 255) && (verde == 0) && (azul == 0)
              x = [x i];
              y = [y pixvert-j];
         end
      end
  end
end



function contorno_costa
% Grafica una aproximacion polinomial de la 
% linea costal de la Peninsula de Paraguana
  [x1,y1] = captura_puntos_1;
  [x2,y2] = captura_puntos_2;
  
  [s1,a1,b1,c1,d1] = spline_natural(x1,y1);
  [s2,a2,b2,c2,d2] = spline_natural(x2,y2);

  figure
  hold on
  
  n = length(x1);
  m = length(x2);
  
  for i=1:n-1
    plot((x1(i):x1(i+1)),horner((s1(i,:)),(x1(i):x1(i+1)),x1(i)))
  endfor

  for j=1:m-1  
    plot((x2(j):x2(j+1)),horner((s2(j,:)),(x2(j):x2(j+1)),x2(j)))
  endfor
  
endfunction  

function longitud = longitud_linea_costa
% Retorna una aproximacion de la longitud en kilometros de la linea
% costal de la Peninsula de Paraguana
  [x1,y1] = captura_puntos_1;
  [x2,y2] = captura_puntos_2;
  
  [s1,a1,b1,c1,d1] = spline_natural(x1,y1)
  [s2,a2,b2,c2,d2] = spline_natural(x2,y2);

  longitud = 0
  
  n = length(x1);
  m = length(x2);
  
  for i=1:n-1
    longitud = longitud + longitud_arco(a1(i),b1(i),c1(i),d1(i),x1(i),x1(i+1));
  endfor
  
  for j=1:m-1
    longitud = longitud + longitud_arco(a2(j),b2(j),c2(j),d2(j),x2(j),x2(j+1));
  endfor
  
  % La escala del mapa es 
  % 66px == 10km
  % (Verificado por el estudiante que realiza el proyecto)
  
  longitud = longitud/6.6
  
  % Resultado = 241.6876829653139 kilometros.
  
endfunction
