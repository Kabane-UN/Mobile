package com.example.kotlin_auth5_klicker_fb


import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.auth.AuthResult
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase

class MainActivity : AppCompatActivity() {
    var fbAuth = FirebaseAuth.getInstance()
    lateinit var _db: DatabaseReference
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        var counter = 0
        var user_name = findViewById(R.id.user_name) as EditText
        var password = findViewById(R.id.password) as EditText
        var btn_reset = findViewById(R.id.btn_reset) as Button
        var btn_submit = findViewById(R.id.btn_submit) as Button

        btn_reset.setOnClickListener {
            user_name.setText("")
            password.setText("")
        }
        btn_submit.setOnClickListener {view ->
            val cur_user_name = user_name.text.toString()
            val cur_password = password.text.toString()
            signIn(view,cur_user_name, cur_password)


            val myRef = FirebaseDatabase.getInstance("https://kotlin-643b9-default-rtdb.europe-west1.firebasedatabase.app/").reference
            val secondFragment = BlankFragment()
            supportFragmentManager.beginTransaction()
                .replace(R.id.fragment_container, secondFragment)
                .addToBackStack(null) // Для возврата назад
                .commit()




            val myToast = Toast.makeText(this, "!!!", Toast.LENGTH_SHORT)
            myToast.show()
            Toast.makeText(this@MainActivity, cur_user_name, Toast.LENGTH_LONG).show()

        }
    }
    fun signIn(view: View, email: String, password: String){

        val myToast = Toast.makeText(this, "email="+email+" pas="+password, Toast.LENGTH_LONG)
        myToast.show()


        fbAuth.signInWithEmailAndPassword(email, password).addOnCompleteListener(this, OnCompleteListener<AuthResult> { task ->
            if(task.isSuccessful){

                val myToast = Toast.makeText(this, "done!", Toast.LENGTH_SHORT)
                myToast.show()

            }else{
                val myToast = Toast.makeText(this, "failed :-(", Toast.LENGTH_SHORT)
                myToast.show()
            }
        })

    }
}