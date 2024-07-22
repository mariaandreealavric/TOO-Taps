package io.andreealavric.fingerfy

import android.app.Application
import android.content.SharedPreferences
import androidx.preference.PreferenceManager
import androidx.room.Room
import com.google.firebase.FirebaseApp
import timber.log.Timber

class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Inizializza Firebase
        FirebaseApp.initializeApp(this)

        // Inizializza Timber
        if (BuildConfig.DEBUG) {
            Timber.plant(Timber.DebugTree())
        } else {
            Timber.plant(ReleaseTree())
        }

        // Inizializza Room database
        database = Room.databaseBuilder(applicationContext, AppDatabase::class.java, "my-database")
            .fallbackToDestructiveMigration()
            .build()

        // Inizializza SharedPreferences
        sharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)
    }

    companion object {
        lateinit var database: AppDatabase
        lateinit var sharedPreferences: SharedPreferences
    }

    private class ReleaseTree : Timber.Tree() {
        override fun log(priority: Int, tag: String?, message: String, t: Throwable?) {
            // Implementazione per il logging in produzione
        }
    }
}
