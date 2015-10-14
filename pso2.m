# ========== PARTICAL SWARM OPTIMIZATION SIMULATION - CHANDELIER =============================
# 
# 	EXAMPLE: 	minimize 	f(x, y) = sqrt(x^ 2 + y^ 2) + 3 * cos(sqrt(x^2 + y^2)) + 5;
#		
#	GROUP MEMBERS:	 Emily Le, Mathew Dohlen, Steven Sairafian, Wynne Tran
#
# =========================================================================================

# ========== DEFINE CONSTANTS & FUNCTIONS =================================================
#
#	n 			= number of particles in the system
#	c1, c2 		= importace weight of personal and global best
#					- usually c1 + c2 = 4 or c1 = c1 = 2
#	vMax		= speed of particles from iteration to iteration
#	iteration 	= number of iterations before ending the program
#	
# ========================================================================================= 
n = 50;
c1 = 0.5;
c2 = 0.5;
vMax = 0.2;
iteration = 110;	 

# DEFINED FUNCTION:  will return z values of the graph given x and y values
function retval = f(xx, yy)
	retval = sqrt(xx .^ 2 + yy .^ 2) + 3 * cos(sqrt(xx .^2 + yy .^2)) + 5;
endfunction

# DEFINED FUNCTION: finds gBest
function retval = findGBest(gBest, position)
	for i = 1:10
		if (f(position(i,1), position(i,2)) < f(gBest(1), gBest(2)))
			gBest = position(i,:);
		endif
	endfor
	retval = gBest;
endfunction

# DEFINED FUCNCTION: that will plot a scatter plot on a mesh graph
function graphPSO(x, y, z, i)
		#clear graph
		clf;

		figure(1, "position", [0,0, 1200, 1000]);

		tx = linspace(-20, 20, 41);
		ty = linspace(-20, 20, 41);
		[xx, yy] = meshgrid (tx, ty);

		# scatter plot overlay
		scatter3 (x, y, z);

		# will allow an overlay of plots
		hold on;

		# function goes here
		tz = sqrt(xx .^ 2 + yy .^ 2) + 3 * cos(sqrt(xx .^2 + yy .^2)) + 5;
		mesh(tx,ty,tz);


		# configure title & label names
		title("Minimize Chandelier Function");
		xlabel("X");
		ylabel("Y");
		zlabel("Z");

		#view (150, -30);
		view(i + 150, -30);

		plotname = ['Chandelier', num2str(i), '.png'];
		print(plotname, '-dpng');

		pause;
		
endfunction

# ========== INITIALIZATION ===============================================================
#
# 	initialzing intiial positions, vectors, lBest, gBest for the first iteration
#
# =========================================================================================
# vector
vector = zeros(n,2);

# position
position =  zeros(n,2);
z = zeros(n,1);

x = (rand(1,n)* 40) - 20; 
y = (rand(1,n)* 40) - 20;

for i = 1:n
	position(i,1) = x(i);
	position(i,2) = y(i);
	z(i,1) = f(x(i),y(i));
endfor

# lBest
lBest = position;

# gBest
gBest = zeros(1,2) + 1000;
gBest = findGBest(gBest, position);

# ========== PLOT INITIAL POINTS ON GRAPH =====================================================
#  
# `Will plot the initial scatter plot on mesh grapgh for the first iteration
#	`	- note that the velocities are initilzed to be 0
# 
# =============================================================================================
graphPSO(position(:,1), position(:,2), z, 100);

# ========== PSO ITERATION =====================================================================
#
# 	Based on the formula:
#
#		v[] = v[] + c1 * rand() * (pbest[] - present[]) + c2 * rand() * (gbest[] - present[]) 
#		present[] = persent[] + v[] 
#
#	This essentially will update the velocity that will be used to update the new position after
#	each iteration.
#
# ==============================================================================================
for i = 1:iteration
	for j = 1:n
		prevPosition = position;
		r1 = rand(1,1);
		r2 = rand(1,1);
		vector(j,:) = vector(j,:) + c1 * r1 * (lBest(j,:) - position(j,:)) + c2 * r2 * (gBest - position(j,:));

		# Limit x-coordinate velocities
		if (vector(j,1) > vMax)
			vector(j,1) = vMax;
		elseif (vector(j,1) < -vMax)
			vector(j,1) = -vMax;
		endif

		# Limit y-coordinate velocities
		if (vector(j,2) > vMax)
			vector(j,2) = vMax;
		elseif (vector(j,2) < -vMax)
			vector(j,2) = -vMax;
		endif

		position(j,:) = position(j,:) + vector(j,:);
		
		# update lBest and gBest values
		if (f(position(j,1), position(j,2)) > f(prevPosition(j,1),prevPosition(j,2)));
			lBest(j,:) = prevPosition(j,:);
		endif

		# update z values
		z(j,1) = f(position(j,1),position(j,2));
	endfor                                            

	gBest = findGBest(gBest, position);

	# draw udated graph
	graphPSO(position(:,1), position(:,2), z, i+100);
endfor