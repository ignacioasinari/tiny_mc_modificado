/* photons.c modificado */

#include <math.h>
#include <stdlib.h> // Necesario para RAND_MAX si se dejara alguna llamada, aunque las quitamos
#include <float.h> // Para FLT_MIN

#include "params.h"
#include "mtwister.h"

//para aceptar el estado del RNG
void photon(float* heats, float* heats_squared, MTRand* rng_state)
{
    const float albedo = MU_S / (MU_S + MU_A);
    const float shells_per_mfp = 1e4 / MICRONS_PER_SHELL / (MU_A + MU_S);

    /* launch */
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    float u = 0.0f;
    float v = 0.0f;
    float w = 1.0f;
    float weight = 1.0f;

    for (;;) {
        float random_val_step = (float)genRand(rng_state);
        float t = -logf(random_val_step); /* move */
        x += t * u;
        y += t * v;
        z += t * w;

        unsigned int shell = sqrtf(x * x + y * y + z * z) * shells_per_mfp; /* absorb */
        if (shell > SHELLS - 1) {
            shell = SHELLS - 1;
        }
        heats[shell] += (1.0f - albedo) * weight;
        heats_squared[shell] += (1.0f - albedo) * (1.0f - albedo) * weight * weight; /* add up squares */
        weight *= albedo;

        /* New direction, rejection method */
        float xi1, xi2;
        do {
            // <-- Usar genRand para xi1 y xi2
            xi1 = 2.0f * (float)genRand(rng_state) - 1.0f;
            xi2 = 2.0f * (float)genRand(rng_state) - 1.0f;
            t = xi1 * xi1 + xi2 * xi2;
        } while (1.0f < t);
        u = 2.0f * t - 1.0f;
        // Evitar división por cero si t es 0
        if (t > 0) { // Añadir esta comprobación por seguridad
           float inv_t_sqrt = sqrtf((1.0f - u * u) / t);
           v = xi1 * inv_t_sqrt;
           w = xi2 * inv_t_sqrt;
        } else {
           // Si t es 0, u= -1. Mantener v=0, w=0
           v = 0.0f;
           w = 0.0f;
        }


        if (weight < 0.001f) { /* roulette */
            //genRand para la ruleta rusa
            if ((float)genRand(rng_state) > 0.1f)
                break;
            weight /= 0.1f;
        }
    }
}
