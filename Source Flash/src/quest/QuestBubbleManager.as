package quest
{
   import com.pickgliss.utils.ObjectUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class QuestBubbleManager extends EventDispatcher
   {
      
      private static var _instance:QuestBubbleManager;
       
      
      private var _view:QuestBubble;
      
      private var _model:QuestBubbleMode;
      
      public const SHOWTASKTIP:String = "show_task_tip";
      
      public function QuestBubbleManager()
      {
         super();
      }
      
      public static function get Instance() : QuestBubbleManager
      {
         if(_instance == null)
         {
            _instance = new QuestBubbleManager();
         }
         return _instance;
      }
      
      public function get view() : QuestBubble
      {
         return this._view;
      }
      
      public function show() : void
      {
         if(this._view)
         {
            return;
         }
         this._model = new QuestBubbleMode();
         if(this._model.questsInfo.length <= 0)
         {
            this._model = null;
            dispatchEvent(new Event(this.SHOWTASKTIP));
            return;
         }
         this._view = new QuestBubble();
         this._view.start(this._model.questsInfo);
         this._view.show();
      }
      
      public function dispose(param1:Boolean = false) : void
      {
         ObjectUtils.disposeObject(this._view);
         this._view = null;
      }
   }
}
