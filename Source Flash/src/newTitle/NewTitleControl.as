package newTitle
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import newTitle.event.NewTitleEvent;
   import newTitle.view.NewTitleFrame;
   
   public class NewTitleControl extends EventDispatcher
   {
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private static var _instance:NewTitleControl;
       
      
      private var _titleFrame:NewTitleFrame;
      
      public function NewTitleControl(target:IEventDispatcher = null)
      {
         super(target);
      }
      
      public static function get instance() : NewTitleControl
      {
         if(!_instance)
         {
            _instance = new NewTitleControl();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         NewTitleManager.instance.addEventListener("newTitleOpenView",this.__onOpenView);
      }
      
      protected function __onOpenView(event:NewTitleEvent) : void
      {
         this.show();
      }
      
      public function show() : void
      {
         if(loadComplete)
         {
            this.showTitleFrame();
         }
         else if(useFirst)
         {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener("close",this.__onClose);
            UIModuleLoader.Instance.addEventListener("uiMoudleProgress",this.__progressShow);
            UIModuleLoader.Instance.addEventListener("uiModuleComplete",this.__complainShow);
            UIModuleLoader.Instance.addUIModuleImp("newTitle");
         }
      }
      
      private function __complainShow(event:UIModuleEvent) : void
      {
         if(event.module == "newTitle")
         {
            UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
            UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__progressShow);
            UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__complainShow);
            UIModuleSmallLoading.Instance.hide();
            loadComplete = true;
            useFirst = false;
            this.show();
         }
      }
      
      private function __progressShow(event:UIModuleEvent) : void
      {
         if(event.module == "newTitle")
         {
            UIModuleSmallLoading.Instance.progress = event.loader.progress * 100;
         }
      }
      
      protected function __onClose(event:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener("close",this.__onClose);
         UIModuleLoader.Instance.removeEventListener("uiMoudleProgress",this.__progressShow);
         UIModuleLoader.Instance.removeEventListener("uiModuleComplete",this.__complainShow);
      }
      
      private function showTitleFrame() : void
      {
         this._titleFrame = ComponentFactory.Instance.creatComponentByStylename("newTitle.newTitleView");
         this._titleFrame.show();
      }
      
      public function hide() : void
      {
         if(this._titleFrame)
         {
            this._titleFrame.dispose();
            this._titleFrame = null;
         }
      }
   }
}
