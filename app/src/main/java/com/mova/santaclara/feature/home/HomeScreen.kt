package com.mova.santaclara.feature.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.mova.santaclara.ui.theme.MOVATheme

/**
 * Pantalla principal de MOVA (Mega Prompt §72).
 * Interfaz limpia, moderna, rápida, con pocos elementos y botones grandes.
 */
@Composable
fun HomeScreen(
    onSearchClick: () -> Unit,
    onBookingsClick: () -> Unit,
    onFavoritesClick: () -> Unit,
    onProfileClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(
        modifier = modifier
            .fillMaxSize()
            .padding(24.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
    ) {
        Text(
            text = "MOVA",
            fontSize = 34.sp,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.primary,
        )
        Text(
            text = "Tu ciudad. Tu ruta. Tu movimiento.",
            color = MaterialTheme.colorScheme.onBackground,
        )

        Spacer(modifier = Modifier.height(8.dp))

        MovaActionButton(text = "🚕 Buscar transporte", onClick = onSearchClick)
        MovaActionButton(text = "📅 Mis reservas", onClick = onBookingsClick)
        MovaActionButton(text = "❤️ Favoritos", onClick = onFavoritesClick)
        MovaActionButton(text = "👤 Mi cuenta", onClick = onProfileClick)
    }
}

@Composable
private fun MovaActionButton(text: String, onClick: () -> Unit) {
    Button(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth(),
    ) {
        Text(text = text, fontSize = 18.sp)
    }
}

@Preview(showBackground = true)
@Composable
private fun HomePreview() {
    MOVATheme {
        HomeScreen(
            onSearchClick = {},
            onBookingsClick = {},
            onFavoritesClick = {},
            onProfileClick = {},
        )
    }
}
