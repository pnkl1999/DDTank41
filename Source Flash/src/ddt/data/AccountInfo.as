package ddt.data
{
   import com.hurlant.crypto.rsa.RSAKey;
   
   public class AccountInfo
   {
       
      
      public var Account:String;
      
      public var Password:String;
      
      public var Key:RSAKey;
      
      public function AccountInfo()
      {
         super();
      }
   }
}
