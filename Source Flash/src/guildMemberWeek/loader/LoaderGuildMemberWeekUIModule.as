package guildMemberWeek.loader
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.controls.Frame;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   
   public class LoaderGuildMemberWeekUIModule extends Frame
   {
      
      private static var _instance:LoaderGuildMemberWeekUIModule;
       
      
      private var _func:Function;
      
      private var _funcParams:Array;
      
      private var _LoadResourseOK:Boolean = false;
      
      public function LoaderGuildMemberWeekUIModule(param1:PrivateClass)
      {
         super();
      }
      
      public static function get Instance() : LoaderGuildMemberWeekUIModule
      {
         if(LoaderGuildMemberWeekUIModule._instance == null)
         {
            LoaderGuildMemberWeekUIModule._instance = new LoaderGuildMemberWeekUIModule(new PrivateClass());
         }
         return LoaderGuildMemberWeekUIModule._instance;
      }
      
      public function loadUIModule(param1:Function = null, param2:Array = null) : void
      {
         this._func = param1;
         this._funcParams = param2;
         if(!this._LoadResourseOK)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.GUILDMEMBERWEEK);
         }
         else
         {
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         this._LoadResourseOK = true;
         if(param1.module == UIModuleTypes.GUILDMEMBERWEEK)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            if(null != this._func)
            {
               this._func.apply(null,this._funcParams);
            }
            this._func = null;
            this._funcParams = null;
         }
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CHRISTMAS)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
   }
}

class PrivateClass
{
    
   
   function PrivateClass()
   {
      super();
   }
}
