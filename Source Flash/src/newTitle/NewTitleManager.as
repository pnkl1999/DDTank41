package newTitle
{
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.SocketManager;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import newTitle.analyzer.NewTitleDataAnalyz;
   import newTitle.model.NewTitleModel;
   import road7th.comm.PackageIn;
   
   public class NewTitleManager extends EventDispatcher
   {
      
      public static var FIRST_TITLEID:int = 602;
      
      public static var loadComplete:Boolean = false;
      
      public static var useFirst:Boolean = true;
      
      private static var _instance:NewTitleManager;
       
      
      public var ShowTitle:Boolean = true;
      
      private var _titleInfo:Dictionary;
      
      private var _titleArray:Array;
      
      public function NewTitleManager(target:IEventDispatcher = null)
      {
         super();
      }
      
      public static function get instance() : NewTitleManager
      {
         if(!_instance)
         {
            _instance = new NewTitleManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NewTitle,this.__onGetHideTitleFlag);
      }
      
      protected function __onGetHideTitleFlag(event:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = event.pkg;
         NewTitleManager.instance.ShowTitle = !_loc2_.readBoolean();
      }
      
      public function newTitleDataSetup(analyzer:NewTitleDataAnalyz) : void
      {
         var _loc2_:* = undefined;
         this._titleInfo = analyzer.list;
         this._titleArray = [];
         var _loc3_:* = this._titleInfo;
         for(_loc2_ in this._titleInfo)
         {
            this._titleArray.push(this._titleInfo[_loc2_]);
         }
         this._titleArray.sortOn("Order",16);
      }
      
      public function getTitleByName(name:String) : NewTitleModel
      {
         var _loc3_:int = 0;
         var _loc2_:NewTitleModel = null;
         _loc3_ = 0;
         while(_loc3_ < this._titleArray.length)
         {
            if(this._titleArray[_loc3_].Name == name)
            {
               _loc2_ = this._titleArray[_loc3_];
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getTitleInfoByID(id:int) : NewTitleModel
      {
         return this._titleInfo[id];
      }
      
      public function get titleInfo() : Dictionary
      {
         return this._titleInfo;
      }
      
      public function get titleArray() : Array
      {
         return this._titleArray;
      }
   }
}
