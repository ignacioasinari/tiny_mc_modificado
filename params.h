#pragma once

#include <time.h> // time

#ifndef SHELLS
#define SHELLS 695 // discretization level
#endif

#ifndef PHOTONS
#define PHOTONS 3000000 // 32K photons
#endif

#ifndef MU_A
#define MU_A 6.7f // Absorption Coefficient in 1/cm !!non-zero!!
#endif

#ifndef MU_S
#define MU_S 52.1f // Reduced Scattering Coefficient in 1/cm
#endif

#ifndef MICRONS_PER_SHELL
#define MICRONS_PER_SHELL 10 // Thickness of spherical shells in microns
#endif

#ifndef SEED
#define SEED 368876 // random seed
#endif

