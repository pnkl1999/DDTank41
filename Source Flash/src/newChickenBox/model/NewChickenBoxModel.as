package newChickenBox.model
{
   import flash.events.EventDispatcher;
   import newChickenBox.view.NewChickenBoxItem;
   
   public class NewChickenBoxModel extends EventDispatcher
   {
      
      private static var _instance:NewChickenBoxModel = null;
       
      
      private var _templateIDList:Array;
      
      private var _changedItem:NewChickenBoxItem;
      
      public var canOpenCounts:int;
      
      public var openCardPrice:Array;
      
      public var canEagleEyeCounts:int;
      
      public var eagleEyePrice:Array;
      
      public var flushPrice:int;
      
      public var boxCount:int;
      
      private var _canclickEnable:Boolean = false;
      
      public var clickEagleEye:Boolean = false;
      
      public var AlertFlush:Boolean = true;
      
      public var alertEye:Boolean = true;
      
      public var alertOpenCard:Boolean = true;
      
      public var countEye:int = 0;
      
      public var currentEyePrice:int;
      
      public var currentCardPrice:int;
      
      public var isShowAll:Boolean;
      
      public var lastFlushTime:Date;
      
      public var freeFlushTime:int;
      
      public var countTime:int = 0;
      
      public var itemList:Array;
      
      public var firstEnterHelp:Boolean = true;
      
      public var freeOpenCardCount:int = 0;
      
      public var freeEyeCount:int = 0;
      
      public var freeRefreshBoxCount:int = 0;
      
      public var endTime:Date;
      
      public function NewChickenBoxModel()
      {
         super();
         if(this._templateIDList == null)
         {
            this._templateIDList = new Array();
            this.openCardPrice = new Array();
            this.eagleEyePrice = new Array();
            this.itemList = new Array();
         }
      }
      
      public static function get instance() : NewChickenBoxModel
      {
         if(_instance == null)
         {
            _instance = new NewChickenBoxModel();
         }
         return _instance;
      }
      
      public function get canclickEnable() : Boolean
      {
         return this._canclickEnable;
      }
      
      public function set canclickEnable(param1:Boolean) : void
      {
         this._canclickEnable = param1;
      }
      
      public function get changedItem() : NewChickenBoxItem
      {
         return this._changedItem;
      }
      
      public function set changedItem(param1:NewChickenBoxItem) : void
      {
         this._changedItem = param1;
      }
      
      public function get templateIDList() : Array
      {
         return this._templateIDList;
      }
      
      public function set templateIDList(param1:Array) : void
      {
         this._templateIDList = param1;
      }
   }
}
