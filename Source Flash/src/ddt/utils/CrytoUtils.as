package ddt.utils
{
   import com.hurlant.crypto.rsa.RSAKey;
   import com.hurlant.math.BigInteger;
   import com.hurlant.util.Base64;
   import flash.utils.ByteArray;
   
   public class CrytoUtils
   {
       
      
      public function CrytoUtils()
      {
         super();
      }
      
      public static function rsaEncry(param1:String, param2:String, param3:String) : String
      {
         return rsaEncry2(Base64.decodeToByteArray(param1),Base64.decodeToByteArray(param2),param3);
      }
      
      public static function rsaEncry2(param1:ByteArray, param2:ByteArray, param3:String) : String
      {
         var _loc4_:BigInteger = new BigInteger(param1);
         var _loc5_:BigInteger = new BigInteger(param2);
         var _loc6_:RSAKey = new RSAKey(_loc4_,_loc5_.intValue());
         return rsaEncry3(_loc6_,param3);
      }
      
      public static function generateRsaKey(param1:String, param2:String) : RSAKey
      {
         return generateRsaKey2(Base64.decodeToByteArray(param1),Base64.decodeToByteArray(param2));
      }
      
      public static function generateRsaKey2(param1:ByteArray, param2:ByteArray) : RSAKey
      {
         var _loc3_:BigInteger = new BigInteger(param1);
         var _loc4_:BigInteger = new BigInteger(param2);
         return new RSAKey(_loc3_,_loc4_.intValue());
      }
      
      public static function rsaEncry3(param1:RSAKey, param2:String) : String
      {
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTF(param2);
         var _loc4_:ByteArray = new ByteArray();
         param1.encrypt(_loc3_,_loc4_,_loc3_.length);
         return Base64.encodeByteArray(_loc4_);
      }
      
      public static function rsaEncry4(param1:RSAKey, param2:ByteArray) : String
      {
         var _loc3_:ByteArray = new ByteArray();
         param1.encrypt(param2,_loc3_,param2.length);
         return Base64.encodeByteArray(_loc3_);
      }
      
      public static function rsaEncry5(param1:RSAKey, param2:ByteArray) : ByteArray
      {
         var _loc3_:ByteArray = new ByteArray();
         param1.encrypt(param2,_loc3_,param2.length);
         return _loc3_;
      }
   }
}
