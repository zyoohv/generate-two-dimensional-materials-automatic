
find2D.x : find2d.o find2d_layer.o find2d_com.o my_math.o phy_const.o kind.o
	ifort -o find2D.x find2d.o find2d_layer.o find2d_com.o my_math.o phy_const.o kind.o
find2d.o : find2d.f90 find2d_com.o my_math.o phy_const.o kind.o
	ifort -c find2d.f90
find2d_layer.o : find2d_layer.f90 find2d_com.o my_math.o phy_const.o kind.o
	ifort -c find2d_layer.f90
find2d_com.o : find2d_com.f90 kind.o
	ifort -c find2d_com.f90
my_math.o : my_math.f90 kind.o
	ifort -c my_math.f90
phy_const.o : phy_const.f90 kind.o
	ifort -c phy_const.f90
kind.o : kind.f90
	ifort -c kind.f90
