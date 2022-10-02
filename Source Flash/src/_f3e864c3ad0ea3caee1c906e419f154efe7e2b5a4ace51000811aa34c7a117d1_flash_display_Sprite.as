package
{
   import flash.display.Sprite;
   import flash.system.Security;
   
   [ExcludeClass]
   public class _f3e864c3ad0ea3caee1c906e419f154efe7e2b5a4ace51000811aa34c7a117d1_flash_display_Sprite extends Sprite
   {
       
      
      public function _f3e864c3ad0ea3caee1c906e419f154efe7e2b5a4ace51000811aa34c7a117d1_flash_display_Sprite()
      {
         super();
      }
      
      public function allowDomainInRSL(... rest) : void
      {
         Security.allowDomain.apply(null,rest);
      }
      
      public function allowInsecureDomainInRSL(... rest) : void
      {
         Security.allowInsecureDomain.apply(null,rest);
      }
   }
}
