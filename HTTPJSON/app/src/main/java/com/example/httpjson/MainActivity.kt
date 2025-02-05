package com.example.httpjson

import android.os.Build
import android.os.Bundle
import android.os.StrictMode
import android.os.StrictMode.ThreadPolicy
import android.widget.ListView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import org.json.JSONArray
import java.net.HttpURLConnection
import java.net.URL


class MainActivity : AppCompatActivity() {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // разрешить внешние соединения
        if (Build.VERSION.SDK_INT > 9) {
            val policy = ThreadPolicy.Builder().permitAll().build()
            StrictMode.setThreadPolicy(policy)
        }

        val url = "https://mysafeinfo.com/api/data?list=titanic&format=json"
        val connection = URL(url).openConnection() as HttpURLConnection
        val responseCode = connection.responseCode

        try {
            val data = connection.inputStream.bufferedReader().use { it.readText() }
            // ... do something with "data"
            val toast = Toast.makeText(applicationContext, data, Toast.LENGTH_LONG)
            toast.show()
            hanldeJson(data)

        } finally {
            connection.disconnect()
        }

    }




    private fun hanldeJson(jsonString: String?) {

        val jsonArray = JSONArray(jsonString)

        val list = ArrayList<President>()
        var x = 0
        while (x < jsonArray.length()) {

            val jsonObject = jsonArray.getJSONObject(x)

            list.add(
                President(
                    jsonObject.getInt("ID"),
                    jsonObject.getString("PassengerName"),
                    jsonObject.getString("Url"),
                    jsonObject.getString("Age"),
                    jsonObject.getString("Job"),
            ))

            x++
        }

        val adapter = ListAdapte(this, list)
        val list2: ListView = findViewById(R.id.president_list);
        list2.setAdapter(adapter);

        val toast = Toast.makeText(applicationContext, x.toString(), Toast.LENGTH_LONG)
        toast.show()


    }
}


