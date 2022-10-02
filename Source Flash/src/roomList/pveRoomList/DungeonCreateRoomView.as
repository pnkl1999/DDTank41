package roomList.pveRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import roomList.pvpRoomList.RoomListCreateRoomView;
   
   public class DungeonCreateRoomView extends RoomListCreateRoomView
   {
       
      
      private var _bossBtn:SimpleBitmapButton;
      
      private var _dungeonBtn:SimpleBitmapButton;
      
      public function DungeonCreateRoomView()
      {
         super();
      }
      
      override protected function initContainer() : void
      {
         _alertInfo = new AlertInfo();
         _alertInfo.title = LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.titleText");
         info = _alertInfo;
         _roomModelBitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.roomModelText");
         addToContent(_roomModelBitmap);
         _createRoomBitmap = ComponentFactory.Instance.creatBitmap("asset.roomList.CreateRoomText");
         addToContent(_createRoomBitmap);
         _textBG = ComponentFactory.Instance.creat("roomList.pvpRoomList.textBg");
         _textBG.setFrame(2);
         addToContent(_textBG);
         _explainTxt = ComponentFactory.Instance.creat("roomList.pvpRoomList.ExplainText");
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215);
         _loc1_.graphics.drawRect(_explainTxt.x,_explainTxt.y,_explainTxt.width,_explainTxt.height);
         _loc1_.graphics.endFill();
         addToContent(_loc1_);
         _explainTxt.text = RoomListCreateRoomView.PREWORD[int(Math.random() * PREWORD.length)];
         addToContent(_explainTxt);
         _passTxt = ComponentFactory.Instance.creat("roomList.pvpRoomList.passText");
         _passTxt.text = "";
         _passTxt.textField.restrict = "0-9 A-Z a-z";
         _passTxt.visible = false;
         addToContent(_passTxt);
         this._bossBtn = ComponentFactory.Instance.creat("roomList.pveRoomList.BOSSBtn");
         addToContent(this._bossBtn);
         this._dungeonBtn = ComponentFactory.Instance.creat("roomList.pveRoomList.dungeonBtn");
         this._dungeonBtn.addEventListener(MouseEvent.CLICK,this.__dungeonBtnClick);
         addToContent(this._dungeonBtn);
         _bg = ComponentFactory.Instance.creatBitmap("asset.roomList.bg_01");
         addToContent(_bg);
         _textbg = ComponentFactory.Instance.creatBitmap("asset.DungeonList.explainText_1");
         addToContent(_textbg);
         _checkBox = ComponentFactory.Instance.creat("roomList.pvpRoomList.simpleSelectBtn");
         addToContent(_checkBox);
         _passBtn = ComponentFactory.Instance.creat("roomList.pvpRoomList.passBtn");
         addToContent(_passBtn);
      }
      
      override protected function __passBtnClick(param1:MouseEvent) : void
      {
         super.__passBtnClick(param1);
         if(_checkBox.selected == true)
         {
         }
      }
      
      private function __dungeonBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      override protected function hide() : void
      {
         SoundManager.instance.play("008");
         this.dispose();
      }
      
      override protected function submit() : void
      {
         if(FilterWordManager.IsNullorEmpty(_explainTxt.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.name"));
            SoundManager.instance.play("008");
         }
         else if(FilterWordManager.isGotForbiddenWords(_explainTxt.text,"name"))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.string"));
            SoundManager.instance.play("008");
         }
         else if(_checkBox.selected && FilterWordManager.IsNullorEmpty(_passTxt.text))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIICreateRoomView.set"));
            SoundManager.instance.play("008");
         }
         else
         {
            GameInSocketOut.sendCreateRoom(_explainTxt.text,4,2,!!_checkBox.selected ? _passTxt.text : "");
            this.hide();
         }
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bossBtn);
         this._bossBtn = null;
         ObjectUtils.disposeObject(this._dungeonBtn);
         this._dungeonBtn = null;
         super.dispose();
      }
   }
}
