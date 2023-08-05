Here's my justification of setting the nodal values to $g(\vec{x})$.
There might be some details missing because this is an online answer and not a math paper.

Let's start with the homogeneous variational problem of finding $u \in V$ such that 

$$
a(u,v) = \mathcal{B}(v) \quad \forall \quad v \in V
$$
where $V$ is the space of $L_2$ functions that vanish at $\Gamma_D$.
Let's assume for simplicity the problem is 2D:

![](dominio-solo-nodos.svg)\ 

Then the Galerkin approximation involves writing both $u$ and $v$ as linear combinations of 32 shape functions $h_j(\vec{x})$ nodal values 

$$
u(\vec{x}) = \sum_{j=1}^{32} h_j(\vec{x}) \cdot u_j = H \cdot \vec{u}
$$

$$
v(\vec{x}) = \sum_{j=1}^{32} h_j(\vec{x}) \cdot v_j = H \cdot \vec{v}
$$

for a matrix $H \in \mathbb{R}^{1 \times 32}$ such that the problem can be casted in matrix form as

$$
A \cdot \vec{u} = \vec{b}
$$
where the elements of the matrix $A$ are

$$
a_{i,j} = a(h_i,h_j)
$$
and the elements of vector $\vec{b}$ are

$$
b_i = \mathcal{B}(h_i)
$$

Note that since the $h_j(\vec{x})$ form a basis of $V$ they all vanish on $\Gamma_D$ so the solution $u(\vec{x})$ also vanishes on $\Gamma_D$.
This procedure is right but it is inconvenient because it is not easy to find the right shape functions.
We can simplify it by allowing nodes to exist on $\Gamma_D$

![](dominio-nodos-elementos.svg)\ 

and "extending" the expansion of $u$ and $v$ with zeros:

$$
u_h(\vec{x}) = \sum_{j=1}^{32} h_j(\vec{x}) \cdot u_j + \sum_{j=33}^{35} h_j(\vec{x}) \cdot 0 = \tilde{H} \cdot \begin{bmatrix}\vec{u} \\ \vec{0}\end{bmatrix}
$$

$$
v(\vec{x}) = \sum_{j=1}^{32} h_j(\vec{x}) \cdot v_j + \sum_{j=33}^{35} h_j(\vec{x} \cdot 0 = \tilde{H} \cdot \begin{bmatrix}\vec{u} \\ \vec{0}\end{bmatrix}
$$
for an extended matrix $\tilde{H} \in \mathbb{R}^{1 \times 35}$.

First we note that these "extended" objects

$$
\tilde{\vec{v}} =
\begin{bmatrix}
\vec{v} \\
\vec{0}
\end{bmatrix}
\quad
\tilde{{A}} =
\begin{bmatrix}
{A} & {C} \\
{D} & {E} \\
\end{bmatrix}
\quad
\tilde{\vec{u}} =
\begin{bmatrix}
\vec{u} \\
\vec{0}
\end{bmatrix}
\quad
\tilde{\vec{b}} =
\begin{bmatrix}
\vec{b} \\
\vec{e}
\end{bmatrix}
$$
still represent the original Galerkin problem.
In effect,

$$
\begin{aligned}
\tilde{\vec{v}}^T \cdot \tilde{{A}} \cdot \tilde{\vec{u}}
&=
\tilde{\vec{v}}^T \cdot \tilde{\vec{b}} \\
\begin{bmatrix} \vec{v}^T & \vec{0}^T \end{bmatrix}
\cdot
\begin{bmatrix}
{A} & {C} \\
{D} & {E} \\
\end{bmatrix}
\cdot
\begin{bmatrix}
\vec{u} \\
\vec{0}
\end{bmatrix}
& =
\begin{bmatrix} \vec{v}^T & \vec{0}^T \end{bmatrix}
\begin{bmatrix}
\vec{b} \\
\vec{e}
\end{bmatrix}
\\
\begin{bmatrix} \vec{v}^T & \vec{0}^T \end{bmatrix}
\cdot
\begin{bmatrix}
{A} \cdot \vec{u} + {C} \cdot \vec{0} \\
{D} \cdot \vec{u} + {E} \cdot \vec{0} \\
\end{bmatrix}
&=
\begin{bmatrix} \vec{v}^T & \vec{0}^T \end{bmatrix}
\begin{bmatrix}
\vec{b} \\
\vec{e}
\end{bmatrix}
\\
\vec{v}^T \cdot {A} \cdot \vec{u} + \vec{0}^T \cdot {D} \cdot \vec{u}
&=
\vec{v}^T \cdot \vec{b} + \vec{0}^T \cdot \vec{e}\\
\vec{v}^T \cdot {A} \cdot \vec{u}
&=
\vec{v}^T \cdot \vec{b}\\
\end{aligned}
$$

Since this identity must hold $\forall \vec{v}$, then ${A} \cdot \vec{u} - \vec{b} = 0$, which is the original homogeneous problem.
We now need to prove that if we have

$$
{K} =
\begin{bmatrix}
{A} & {C} \\
{0} & {I} \\
\end{bmatrix}
\quad
\vec{f} =
\begin{bmatrix}
\vec{b} \\
\vec{0} \\
\end{bmatrix}
$$
such that ${A} \cdot \vec{u} = \vec{b}$, where ${I}$ is the identity matrix of size $3 \times 3$, 
then the vector $\vec{\varphi}$ such that ${K} \cdot \vec{\varphi} = \vec{f}$ is equal to

$$
\vec{\varphi}
 =
\begin{bmatrix}
\vec{u} \\
\vec{0} \\
\end{bmatrix}
$$

Indeed, let $\vec{\varphi} = \begin{bmatrix} \vec{\varphi}_1 & \vec{\varphi}_2 \end{bmatrix}^T$.
Then ${K} \cdot \vec{\varphi}$ is

$$
\begin{bmatrix}
{A} & {C} \\
{0} & {I}
\end{bmatrix}
\cdot
\begin{bmatrix}
\vec{\varphi}_1 \\
\vec{\varphi}_2 
\end{bmatrix}
=
\begin{bmatrix}
{A} \cdot \vec{\varphi}_1 + {C} \cdot \vec{\varphi}_2\\
{0} \cdot \vec{\varphi}_1 + {I} \cdot \vec{\varphi}_2
\end{bmatrix}
=
\begin{bmatrix}
\vec{b}\\
\vec{0}
\end{bmatrix}
$$

From the second row,  $\vec{\varphi}_2 = \vec{0}$.
Replacing this result in the first row, ${A} \cdot \vec{\varphi}_1 = \vec{b}$.
Therefore $\vec{\varphi}_1 = {A}^{-1} \cdot \vec{b} = \vec{u}$.

This part proves that putting a one in the diagonal of the stiffness matrix and a zero in the RHS vector in the rows corresponding to the nodes at $\Gamma_D$ is correct.



Now let's investigate non-homogeneous Dirichlet BCs.
The "lifting" procedure from textbooks translates into finding $u_h \in V$ such that

$$
a(u_h,v) = \mathcal{B}(v) - a(u_g,v) \quad \forall \quad v \in V
$$

where functions in $V$ vanish at $\Gamma_D$, and $u_g$ is a known function (i.e. a known lifting) that satisfies $u_g(\vec{x}) = g(\vec{x})$ for $\vec{x} \in \Gamma_D$.
Note that the right-hand side of the formulation contains known functions only.

Now, let's take back the $u_g$ into the left-hand side (we have already assumed $a$ was bi-linear) then we have to solve

$$
a(u_h+u_g,v) = \mathcal{B}(v)
$$


Let's first write the functions $u_h$ and $v$ over the whole set of nodes

$$
u_h(\vec{x}) = \sum_{j=1}^{32} h_j(\vec{x}) \cdot u_j + \sum_{j=33}^{35} h_j(\vec{x}) \cdot 0 = \tilde{H} \cdot \begin{bmatrix}\vec{u} \\ \vec{0}\end{bmatrix}
$$

$$
v(\vec{x}) = \sum_{j=1}^{32} h_j(\vec{x}) \cdot v_j + \sum_{j=33}^{35} h_j(\vec{x} \cdot 0 = \tilde{H} \cdot \begin{bmatrix}\vec{u} \\ \vec{0}\end{bmatrix}
$$
for another matrix $\tilde{H}$ of size $1 \times 35$.

We then write the non-homogeneos part $u_g$ as

$$
u_h(\vec{x}) = \sum_{j=1}^{32} h_j(\vec{x}) \cdot 0 + \sum_{j=33}^{35} h_j(\vec{x}) \cdot g(\vec{x}_j) = \tilde{H} \cdot \begin{bmatrix}\vec{0} \\ \vec{g}\end{bmatrix}
$$
so the sum $u_h + u_g$ is

$$
u_h(\vec{x}) + u_g(\vec{x}) = \tilde{H} \cdot \begin{bmatrix}\vec{u} \\ \vec{g}\end{bmatrix}
$$

Now, the stiffness matrix of the first homogeneous problem was $A \in \mathbb{R}^{32 \times 32}$.
We then extend it to a new matrix of size $35 \times 35$

$$
\begin{bmatrix}
A & C \\
D & E
\end{bmatrix}
$$
such that the discretized problem is now

$$
\begin{aligned}
\begin{bmatrix}
\vec{v}^T & \vec{0}^T
\end{bmatrix}
\cdot
\begin{bmatrix}
A & C \\
D & E
\end{bmatrix}
\cdot
\begin{bmatrix}
\vec{u} \\
\vec{g}
\end{bmatrix}
&=
\begin{bmatrix}
\vec{v}^T & \vec{0}^T
\end{bmatrix}
\cdot
\begin{bmatrix}
\vec{b} \\ \vec{e}
\end{bmatrix} \\
\begin{bmatrix}
\vec{v}^T & \vec{0}^T
\end{bmatrix}
\cdot
\begin{bmatrix}
A \cdot \vec{u} + C \cdot \vec{g} \\
D \cdot \vec{u} + E \cdot \vec{g}
\end{bmatrix}
&=
\begin{bmatrix}
\vec{v}^T & \vec{0}^T
\end{bmatrix}
\cdot
\begin{bmatrix}
\vec{b} \\ \vec{e}
\end{bmatrix} \\
\vec{v}^T \cdot A \cdot \vec{u} + \vec{v}^T \cdot C \cdot \vec{g} &= \vec{v}^T \cdot \vec{b}
\end{aligned}
$$
for all $\vec{u} \in \mathbb{R}^J$. That is to say,

$$
A \cdot \vec{u} + C \cdot \vec{g} = \vec{b}
$$

Now you can prove as an exercise that if we have

$$
K =
\begin{bmatrix}
A & C \\
0 & I \\
\end{bmatrix}
\quad
\vec{f} =
\begin{bmatrix}
\vec{b} \\
\vec{g} \\
\end{bmatrix}
$$
such that $A \cdot \vec{u} + C \cdot \vec{g} = \vec{b}$, then the vector $\vec{\varphi}$ such that $K \cdot \vec{\varphi} = \vec{f}$ is equal to

$$
\vec{\varphi}
 =
\begin{bmatrix}
\vec{u} \\
\vec{g} \\
\end{bmatrix}
$$






