package ddt.view
{
   import com.pickgliss.utils.ClassUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   [Event(name="close",type="flash.events.Event")]
   public class UIModuleSmallLoading extends EventDispatcher
   {
      
      private static var _instance:UIModuleSmallLoading;
      
      private static const SMALL_LOADING_CLASS:String = "SmallLoading";
      
      private static var _loadingInstance:*;
       
      
      public function UIModuleSmallLoading()
      {
         super();
      }
      
      public static function get Instance() : UIModuleSmallLoading
      {
         if(_instance == null)
         {
            _instance = new UIModuleSmallLoading();
            _loadingInstance = ClassUtils.getDefinition(SMALL_LOADING_CLASS)["Instance"];
            _loadingInstance.addEventListener(Event.CLOSE,__onCloseClick);
         }
         return _instance;
      }
      
      private static function __onCloseClick(param1:Event) : void
      {
         _instance.dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function show(param1:Boolean = true, param2:Boolean = true) : void
      {
         _loadingInstance.show(param1,param2);
      }
      
      public function hide() : void
      {
         _loadingInstance.hide();
      }
      
      public function set progress(param1:int) : void
      {
         _loadingInstance.progress = param1;
      }
      
      public function get progress() : int
      {
         return _loadingInstance.progress;
      }
   }
}
