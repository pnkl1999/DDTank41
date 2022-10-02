package eliteGame.view
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.PlayerPortraitView;
   import eliteGame.EliteGameController;
   import eliteGame.EliteGameEvent;
   import eliteGame.info.EliteGameTopSixteenInfo;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.TextEvent;
   import road7th.data.DictionaryData;
   
   public class EliteGamePaarungFrame extends Frame
   {
       
      
      private var _tilteBmp:Bitmap;
      
      private var _bg:Bitmap;
      
      private var _championBg:Bitmap;
      
      private var _tip1:Bitmap;
      
      private var _tip2:Bitmap;
      
      private var _tip3:Bitmap;
      
      private var _tip4:Bitmap;
      
      private var _between30_40:SelectedCheckButton;
      
      private var _between41_50:SelectedCheckButton;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _isPress1:Boolean = false;
      
      private var _isPress2:Boolean = false;
      
      private var _texts:Object;
      
      private var _topSixteen:Vector.<EliteGameTopSixteenInfo>;
      
      private var _paarungRound:DictionaryData;
      
      private var _protrait:PlayerPortraitView;
      
      private var _playerInfo:PlayerInfo;
      
      public function EliteGamePaarungFrame()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("eliteGame.readyFrame.title");
         this._tilteBmp = ComponentFactory.Instance.creatBitmap("EliteGame.pauungview.title");
         this._bg = ComponentFactory.Instance.creatBitmap("EliteGame.pauungview.BG");
         this._championBg = ComponentFactory.Instance.creatBitmap("EliteGame.pauungview.championBG");
         this._tip1 = ComponentFactory.Instance.creatBitmap("EliteGame.pauungview.16");
         this._tip2 = ComponentFactory.Instance.creatBitmap("EliteGame.pauungview.8");
         this._tip3 = ComponentFactory.Instance.creatBitmap("EliteGame.pauungview.4");
         this._tip4 = ComponentFactory.Instance.creatBitmap("EliteGame.pauungview.2");
         this._between30_40 = ComponentFactory.Instance.creatComponentByStylename("eliteGame.between30_40Btn");
         this._between41_50 = ComponentFactory.Instance.creatComponentByStylename("eliteGame.between41_50Btn");
         addToContent(this._tilteBmp);
         addToContent(this._bg);
         addToContent(this._championBg);
         addToContent(this._tip1);
         addToContent(this._tip2);
         addToContent(this._tip3);
         addToContent(this._tip4);
         addToContent(this._between30_40);
         addToContent(this._between41_50);
         this._texts = new Object();
         this.createText(1,16);
         this.createText(2,8);
         this.createText(3,4);
         this.createText(4,2);
         this.createText(5,1);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._between30_40);
         this._btnGroup.addSelectItem(this._between41_50);
         if(PlayerManager.Instance.Self.Grade >= 41 && PlayerManager.Instance.Self.Grade <= 50)
         {
            this._btnGroup.selectIndex = 1;
         }
         else
         {
            this._btnGroup.selectIndex = 0;
         }
         PositionUtils.setPos(this._between30_40,"eliteGame.paarungView.select1");
         PositionUtils.setPos(this._between41_50,"eliteGame.paarungView.select2");
         EliteGameController.Instance.addEventListener(EliteGameEvent.TOP_SIXTEEN_READY,this.__dataReady);
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         addEventListener(FrameEvent.RESPONSE,this.__responsehandler);
         this.setType(this._btnGroup.selectIndex);
      }
      
      private function createText(param1:int, param2:int) : void
      {
         var _loc4_:EliteGamePaarungText = null;
         _loc4_ = null;
         this._texts[param1] = new Vector.<EliteGamePaarungText>();
         var _loc3_:int = 1;
         while(_loc3_ <= param2)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("eliteGame.paarungView." + param1 + "." + _loc3_);
            _loc4_.addEventListener(TextEvent.LINK,this.__onTextClicked);
            _loc4_.mouseEnabled = true;
            addToContent(_loc4_);
            this._texts[param1].push(_loc4_);
            _loc3_++;
         }
      }
      
      protected function __onTextClicked(param1:TextEvent) : void
      {
         var _loc2_:EliteGamePaarungText = param1.currentTarget as EliteGamePaarungText;
         SoundManager.instance.play("008");
         PlayerInfoViewControl.viewByID(_loc2_.playerId);
         PlayerInfoViewControl.isOpenFromBag = false;
      }
      
      protected function __responsehandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      protected function __changeHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.setType(this._btnGroup.selectIndex);
      }
      
      private function setType(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               if(!this._isPress1)
               {
                  SocketManager.Instance.out.sendGetPaarungDetail(1);
               }
               this._isPress1 = true;
               this.setData(EliteGameController.Instance.Model.topSixteen30_40,EliteGameController.Instance.Model.paarungRound30_40);
               break;
            case 1:
               if(!this._isPress2)
               {
                  SocketManager.Instance.out.sendGetPaarungDetail(2);
               }
               this._isPress2 = true;
               this.setData(EliteGameController.Instance.Model.topSixteen41_50,EliteGameController.Instance.Model.paarungRound41_50);
         }
      }
      
      protected function __dataReady(param1:EliteGameEvent) : void
      {
         this.setType(this._btnGroup.selectIndex);
      }
      
      public function setData(param1:Vector.<EliteGameTopSixteenInfo>, param2:DictionaryData) : void
      {
         var _loc3_:* = null;
         this._topSixteen = param1;
         this._paarungRound = param2;
         if(this._protrait)
         {
            this._protrait.visible = false;
         }
         this.emptyText();
         if(this._paarungRound)
         {
            for(_loc3_ in this._paarungRound)
            {
               this.addText(_loc3_,this._paarungRound[_loc3_]);
            }
         }
      }
      
      private function emptyText() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         for(_loc1_ in this._texts)
         {
            _loc2_ = 0;
            while(_loc2_ < this._texts[_loc1_].length)
            {
               this._texts[_loc1_][_loc2_].text = "";
               _loc2_++;
            }
         }
      }
      
      private function clearTexts() : void
      {
         var _loc1_:* = null;
         var _loc2_:int = 0;
         for(_loc1_ in this._texts)
         {
            _loc2_ = 0;
            while(_loc2_ < this._texts[_loc1_].length)
            {
               ObjectUtils.disposeObject(this._texts[_loc1_][_loc2_]);
               this._texts[_loc1_][_loc2_] = null;
               _loc2_++;
            }
            this._texts[_loc1_] = null;
         }
         this._texts = null;
      }
      
      private function addText(param1:String, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 == "5")
         {
            if(this._protrait == null)
            {
               this._protrait = ComponentFactory.Instance.creatCustomObject("eliteGame.GiftBannerPortrait",["right"]);
               addToContent(this._protrait);
            }
            this._protrait.visible = true;
            this._playerInfo = PlayerManager.Instance.findPlayer(param2[0]);
            if(this._playerInfo.Style == null)
            {
               SocketManager.Instance.out.sendItemEquip(param2[0],false);
               this._playerInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__infoHandler);
            }
            else
            {
               this._protrait.info = this._playerInfo;
            }
            this._texts["5"][0].htmlText = "<a href=\"event:\">" + this.getNameWithId(param2[0]) + "</a>";
            this._texts["5"][0].playerId = param2[0];
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < param2.length)
            {
               _loc4_ = 0;
               while(_loc4_ < this._texts[param1].length)
               {
                  if(this._texts[param1][_loc4_].canAccept(this.getRankWithId(param2[_loc3_])))
                  {
                     this._texts[param1][_loc4_].htmlText = "<a href=\"event:\">" + this.getNameWithId(param2[_loc3_]) + "</a>";
                     this._texts[param1][_loc4_].playerId = param2[_loc3_];
                     break;
                  }
                  _loc4_++;
               }
               _loc3_++;
            }
         }
      }
      
      protected function __infoHandler(param1:PlayerPropertyEvent) : void
      {
         this._playerInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__infoHandler);
         this._protrait.info = this._playerInfo;
      }
      
      private function getRankWithId(param1:int) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._topSixteen.length)
         {
            if(param1 == this._topSixteen[_loc2_].id)
            {
               return this._topSixteen[_loc2_].rank;
            }
            _loc2_++;
         }
         return 0;
      }
      
      private function getNameWithId(param1:int) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._topSixteen.length)
         {
            if(param1 == this._topSixteen[_loc2_].id)
            {
               return this._topSixteen[_loc2_].name;
            }
            _loc2_++;
         }
         return "";
      }
      
      override public function dispose() : void
      {
         EliteGameController.Instance.removeEventListener(EliteGameEvent.TOP_SIXTEEN_READY,this.__dataReady);
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         removeEventListener(FrameEvent.RESPONSE,this.__responsehandler);
         if(this._tilteBmp)
         {
            ObjectUtils.disposeObject(this._tilteBmp);
         }
         this._tilteBmp = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._championBg)
         {
            ObjectUtils.disposeObject(this._championBg);
         }
         this._championBg = null;
         if(this._tip1)
         {
            ObjectUtils.disposeObject(this._tip1);
         }
         this._tip1 = null;
         if(this._tip2)
         {
            ObjectUtils.disposeObject(this._tip2);
         }
         this._tip2 = null;
         if(this._tip3)
         {
            ObjectUtils.disposeObject(this._tip3);
         }
         this._tip3 = null;
         if(this._tip4)
         {
            ObjectUtils.disposeObject(this._tip4);
         }
         this._tip4 = null;
         if(this._between30_40)
         {
            ObjectUtils.disposeObject(this._between30_40);
         }
         this._between30_40 = null;
         if(this._between41_50)
         {
            ObjectUtils.disposeObject(this._between41_50);
         }
         this._between41_50 = null;
         this.clearTexts();
         this._texts = null;
         this._topSixteen = null;
         this._paarungRound = null;
         super.dispose();
      }
   }
}
