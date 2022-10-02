package hallIcon.model
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import hallIcon.event.HallIconEvent;
   
   public class HallIconModel extends EventDispatcher
   {
       
      
      public var expblessedIsOpen:Boolean;
      
      public var expblessedValue:int;
      
      public var vipLvlIsOpen:Boolean;
      
      public var kingBlessIsOpen:Boolean;
      
      public var wonderFulPlayIsOpen:Boolean;
      
      public var everyDayActivityIsOpen:Boolean;
      
      public var activityIsOpen:Boolean;
      
      public var firstRechargeIsOpen:Boolean;
      
      public var cacheRightIconDic:Dictionary;
      
      public var cacheRightIconTask:Object;
      
      public var cacheRightIconLevelLimit:Dictionary;
      
      public function HallIconModel(target:IEventDispatcher = null)
      {
         super(target);
         this.cacheRightIconDic = new Dictionary();
         this.cacheRightIconLevelLimit = new Dictionary();
      }
      
      public function dataChange(_eventType:String, _resultData:Object = null) : void
      {
         dispatchEvent(new HallIconEvent(_eventType,_resultData));
      }
   }
}
