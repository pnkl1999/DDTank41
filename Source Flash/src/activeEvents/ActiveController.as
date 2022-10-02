package activeEvents
{
   import activeEvents.data.ActiveEventsInfo;
   import activeEvents.view.ActiveMainFrame;
   import activeEvents.view.ActiveSubFrame;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.data.UIModuleTypes;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class ActiveController extends EventDispatcher
   {
      
      private static var _instance:ActiveController;
       
      
      private var _activeMainFrame:ActiveMainFrame;
      
      private var _activeSubFrame:ActiveSubFrame;
      
      public function ActiveController()
      {
         super();
      }
      
      public static function get instance() : ActiveController
      {
         if(!_instance)
         {
            _instance = new ActiveController();
         }
         return _instance;
      }
      
      public function get actives() : Array
      {
         return ActiveEventsManager.Instance.model.actives;
      }
      
      public function set activeMainFrame(param1:ActiveMainFrame) : void
      {
         this._activeMainFrame = param1;
      }
      
      public function set activeSubFrame(param1:ActiveSubFrame) : void
      {
         this._activeSubFrame = param1;
      }
      
      public function show() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__activeComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.ACTIVE_EVENTS);
      }
      
      private function __onClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__activeComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
      }
      
      private function __activeProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __activeComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.ACTIVE_EVENTS)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__activeProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__activeComplete);
            if(!this._activeMainFrame)
            {
               this._activeMainFrame = ComponentFactory.Instance.creatComponentByStylename("activeEvents.activeMainFrame");
               this._activeMainFrame.control = this;
               this._activeMainFrame.show();
            }
            else
            {
               this.closeAllFrame();
            }
         }
      }
      
      public function get isShowing() : Boolean
      {
         return this._activeMainFrame != null && this._activeMainFrame.parent != null;
      }
      
      public function closeAllFrame() : void
      {
         if(this._activeMainFrame)
         {
            this._activeMainFrame.dispose();
            this._activeMainFrame = null;
         }
         if(this._activeSubFrame)
         {
            this._activeSubFrame.dispose();
            this._activeSubFrame = null;
         }
      }
      
      public function closeSubFrame() : void
      {
         if(this._activeSubFrame)
         {
            this._activeSubFrame.dispose();
            this._activeSubFrame = null;
         }
      }
      
      public function openSubFrame(param1:ActiveEventsInfo) : void
      {
         if(!this._activeSubFrame)
         {
            this._activeSubFrame = ComponentFactory.Instance.creatComponentByStylename("activeEvents.activeSubFrame");
            this._activeSubFrame.control = this;
         }
         this._activeSubFrame.show();
         this._activeSubFrame.x = this._activeMainFrame.x + this._activeMainFrame.width;
         this._activeSubFrame.y = this._activeMainFrame.y;
         this._activeSubFrame.receiveItem(param1);
      }
   }
}
