package com.mova.santaclara.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable

import com.mova.santaclara.feature.home.HomeScreen
import com.mova.santaclara.feature.splash.SplashScreen

/**
 * Grafo de navegación principal de MOVA.
 * Se protege por autenticación/rol en fases posteriores.
 */
@Composable
fun MovaNavGraph(
    navController: NavHostController,
    startDestination: String = MovaDestinations.HOME,
) {
    NavHost(
        navController = navController,
        startDestination = startDestination,
    ) {
        composable(MovaDestinations.SPLASH) {
            SplashScreen(
                onFinished = {
                    navController.navigate(MovaDestinations.HOME) {
                        popUpTo(MovaDestinations.SPLASH) { inclusive = true }
                    }
                }
            )
        }
        composable(MovaDestinations.HOME) {
            HomeScreen(
                onSearchClick = { navController.navigate(MovaDestinations.SEARCH) },
                onBookingsClick = { navController.navigate(MovaDestinations.BOOKINGS) },
                onFavoritesClick = { navController.navigate(MovaDestinations.FAVORITES) },
                onProfileClick = { navController.navigate(MovaDestinations.PROFILE) },
            )
        }
    }
}
