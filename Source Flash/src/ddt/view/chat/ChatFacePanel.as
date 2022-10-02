package ddt.view.chat
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class ChatFacePanel extends ChatBasePanel
   {
      
      private static const MAX_FACE_CNT:uint = 49;
      
      private static const COLUMN_LENGTH:uint = 10;
      
      private static const FACE_SPAN:uint = 25;
       
      
      private var _bg:Bitmap;
      
      private var _faceBtns:Vector.<BaseButton>;
      
      private var _inGame:Boolean;
      
      private var _selected:int;
      
      public function ChatFacePanel(param1:Boolean = false)
      {
         this._faceBtns = new Vector.<BaseButton>();
         super();
         this._inGame = param1;
      }
      
      public function dispose() : void
      {
         var _loc1_:BaseButton = null;
         removeChild(this._bg);
         for each(_loc1_ in this._faceBtns)
         {
            _loc1_.dispose();
         }
         this._faceBtns = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get selected() : int
      {
         return this._selected;
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         var _loc2_:String = (param1.target as BaseButton).backStyle;
         SoundManager.instance.play("008");
         this._selected = int(_loc2_.slice(_loc2_.length - 2));
         dispatchEvent(new Event(Event.SELECT));
      }
      
      override protected function init() : void
      {
         var _loc2_:uint = 0;
         var _loc6_:BaseButton = null;
         var _loc1_:Point = null;
         _loc2_ = 0;
         _loc6_ = null;
         super.init();
         this._bg = ComponentFactory.Instance.creat("asset.chat.FacePanelBg");
         addChild(this._bg);
         _loc1_ = ComponentFactory.Instance.creatCustomObject("chat.FacePanelFacePos");
         _loc2_ = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = PathManager.solveChatFaceDisabledList();
         var _loc5_:int = 1;
         while(_loc5_ < MAX_FACE_CNT)
         {
            if(!(_loc4_ && _loc4_.indexOf(String(_loc5_)) > -1))
            {
               if(_loc3_ == COLUMN_LENGTH)
               {
                  _loc3_ = 0;
                  _loc2_++;
               }
               _loc6_ = new BaseButton();
               _loc6_.beginChanges();
               _loc6_.backStyle = "asset.chat.FaceBtn_" + (_loc5_ < 10 ? "0" + String(_loc5_) : String(_loc5_));
               _loc6_.tipStyle = "core.ChatFaceTips";
               _loc6_.tipDirctions = "4";
               _loc6_.tipGapV = 5;
               _loc6_.tipGapH = -5;
               _loc6_.tipData = LanguageMgr.GetTranslation("tank.view.chat.ChatFacePannel.face" + String(_loc5_));
               _loc6_.commitChanges();
               _loc6_.x = _loc3_ * FACE_SPAN + _loc1_.x;
               _loc6_.y = _loc2_ * FACE_SPAN + _loc1_.y;
               _loc6_.addEventListener(MouseEvent.CLICK,this.__itemClick);
               this._faceBtns.push(_loc6_);
               addChild(_loc6_);
               _loc3_++;
            }
            _loc5_++;
         }
      }
   }
}
