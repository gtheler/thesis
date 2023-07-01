# README para la generación de dibujitos

## Figura "solo nodos adentro"

 1. generar `dominio.msh` (en 2.2 porque es más facil de renumerar)
 
    ```
    gmsh -2 dominio.geo
    ```
 2. hay que renumerar el `dominio.msh`
 
    - 14 <-> 33
    - 15 <-> 34
    - 16 <-> 35
 
 3. abrir el geo y el msh con el GUI
 
    ```
    gmsh dominio-solo-nodos.geo 
    ```
    
 4. hide nodos 33-35
 
 5. save as svg
 
    
## Figura "todos los nodos con elementos"

 1. abrir el geo y el msh con el GUI
 
    ```
    gmsh dominio-nodos-elementos.geo
    ```

## Figuras shape-function-first-order-*

 1. generar una malla `dominio-dummy-function.msh` con una funcion dummy igual a 0 en todos los nodos
 
    ```
    shape-function-first-order-dummy.fee
    ```
    
 2. correr `shape-function-first-order.fee` que lee la malla de recién, pone un 1 en la $h$ del argumento (default 25) y graba una malla `shape-function-first-order-$1.msh`
 
    ```
    feenox shape-function-first-order.fee 25
    ```
   
 3. abrir `shape-function-first-order-25.geo` y generar un png

 
## Lo mismo pero second-order

 1. convertir `dominio.msh` a segundo orden y dejarlo en `dominio2.msh`
 
    ```
    gmsh -2 dominio.msh -order 2 -o dominio2.msh
    ```
    
 2. correr `shape-function-second-order-dummy.fee`
 
    ```
    feenox shape-function-second-order-dummy.fee
    ```

 3. correr `shape-function-second-order.fee`
 
    ```
    
    ```
