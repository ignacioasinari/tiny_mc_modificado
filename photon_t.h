#pragma once

/* photon.h (ejemplo modificado) */

#ifndef PHOTON_T_H
#define PHOTON_T_H

#include "mtwister.h" // <-- Incluir para que conozca MTRand

// <-- Firma actualizada de la función photon
void photon(float* heats, float* heats_squared, MTRand* rng_state);

#endif // PHOTON_T_H
