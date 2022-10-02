package ddt.manager
{
   import flash.external.ExternalInterface;
   
   public class PageInterfaceManager
   {
       
      
      public function PageInterfaceManager()
      {
         super();
      }
      
      public static function changePageTitle(param1:String) : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("title_effect.tickerBegin",LanguageMgr.GetTranslation("pageInterface.yourturn"));
         }
      }
      
      public static function restorePageTitle() : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("title_effect.tickerStop");
         }
      }
      
      public static function askForFavorite() : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call("AddFavorite",PathManager.solveLogin());
         }
      }
      
      private static function call(param1:String, ... rest) : void
      {
         if(ExternalInterface.available && !DesktopManager.Instance.isDesktop)
         {
            ExternalInterface.call(param1,rest);
         }
      }
   }
}
