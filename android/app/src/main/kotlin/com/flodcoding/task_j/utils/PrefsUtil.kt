package com.flodcoding.task_j.utils

import android.app.Application
import android.content.SharedPreferences
import android.preference.PreferenceManager
import android.util.Base64
import java.io.*

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-03-20
 * UseDes:
 */
object PrefsUtil {

    private var mSharedPreferences: SharedPreferences? = null

    fun init(application: Application) {
        mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(application)
    }

    fun init(application: Application, name: String, mode: Int) {
        mSharedPreferences = application.getSharedPreferences(name, mode)
    }

    fun putString(key: String, value: String?) {
        mSharedPreferences!!.edit().putString(key, value).apply()
    }

    fun putStringCommit(key: String, value: String?): Boolean {
        return mSharedPreferences!!.edit().putString(key, value).commit()
    }

    fun getString(key: String, defValue: String): String? {
        return mSharedPreferences!!.getString(key, defValue)
    }

    fun putStringSet(key: String, values: Set<String>?) {
        mSharedPreferences!!.edit().putStringSet(key, values).apply()
    }

    fun putStringSetCommit(key: String, values: Set<String>?): Boolean {
        return mSharedPreferences!!.edit().putStringSet(key, values).commit()
    }

    fun StringSet(key: String, defValues: Set<String>): Set<String>? {
        return mSharedPreferences!!.getStringSet(key, defValues)
    }

    fun putInt(key: String, value: Int) {
        mSharedPreferences!!.edit().putInt(key, value).apply()
    }

    fun putIntCommit(key: String, value: Int): Boolean {
        return mSharedPreferences!!.edit().putInt(key, value).commit()
    }

    fun getInt(key: String, defValue: Int): Int {
        return mSharedPreferences!!.getInt(key, -1)
    }


    fun putLong(key: String, value: Long) {
        mSharedPreferences!!.edit().putLong(key, value).apply()
    }


    fun putLongCommit(key: String, value: Long): Boolean {
        return mSharedPreferences!!.edit().putLong(key, value).commit()
    }

    fun getLong(key: String, defValue: Long): Long {
        return mSharedPreferences!!.getLong(key, defValue)
    }

    fun putFloat(key: String, value: Float) {
        mSharedPreferences!!.edit().putFloat(key, value).apply()
    }

    fun putFloatCommit(key: String, value: Float): Boolean {
        return mSharedPreferences!!.edit().putFloat(key, value).commit()
    }

    fun getFloat(key: String, defValue: Float): Float {
        return mSharedPreferences!!.getFloat(key, defValue)
    }

    fun putBoolean(key: String, value: Boolean) {
        mSharedPreferences!!.edit().putBoolean(key, value).apply()
    }

    fun putBooleanCommit(key: String, value: Boolean): Boolean {
        return mSharedPreferences!!.edit().putBoolean(key, value).commit()
    }

    fun getBoolean(key: String): Boolean {
        return mSharedPreferences!!.getBoolean(key, false)
    }

    /**
     * 存放一个实体类，这个实体类需要实现Serializable
     */
    fun putSerializable(key: String, serializable: Serializable?): Boolean {
        if (serializable == null) return false
        val baos = ByteArrayOutputStream()
        try {
            val oos = ObjectOutputStream(baos)
            oos.writeObject(serializable)
            val objBase64 = String(Base64.encode(baos.toByteArray(), Base64.DEFAULT))
            mSharedPreferences!!.edit().putString(key, objBase64).apply()
            baos.close()
            oos.close()
            return true
        } catch (e: IOException) {
            e.printStackTrace()
            return false
        }

    }

    fun getSerializable(key: String): Serializable? {
        val objBase64 = mSharedPreferences!!.getString(key, null) ?: return null
        val bytes = Base64.decode(objBase64, Base64.DEFAULT)
        val bais = ByteArrayInputStream(bytes)
        try {
            val bis = ObjectInputStream(bais)
            val serializable = bis.readObject() as Serializable
            bais.close()
            bis.close()
            return serializable
        } catch (e: Exception) {
            e.printStackTrace()
            return null
        }

    }

    /**
     * 把一个实体类转换成json字符串保存
     */
    /*public static <T> void putEntityToJson(String key, T t) {
        String jsonStr = new Gson().toJson(t);
        mSharedPreferences.edit().putString(key, jsonStr).apply();
    }

    public static <T> boolean putEntityToJsonCommit(String key, T t) {
        String jsonStr = new Gson().toJson(t);
        return mSharedPreferences.edit().putString(key, jsonStr).commit();
    }

    public static <T> T getEntityFromJson(String key, Class<T> tClass) {
        String jsonStr = mSharedPreferences.getString(key, null);
        try {
            return new Gson().fromJson(jsonStr, tClass);
        } catch (JsonSyntaxException e) {
            e.printStackTrace();
            return null;
        }
    }*/

    fun clear() {
        mSharedPreferences!!.edit().clear().apply()
    }

    fun clearCommit(): Boolean {
        return mSharedPreferences!!.edit().clear().commit()
    }

    fun remove(key: String) {
        mSharedPreferences!!.edit().remove(key).apply()
    }

    fun removeCommit(key: String): Boolean {
        return mSharedPreferences!!.edit().remove(key).commit()
    }

}
