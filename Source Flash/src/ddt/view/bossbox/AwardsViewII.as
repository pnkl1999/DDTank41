package ddt.view.bossbox
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.BossBoxManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class AwardsViewII extends Frame
   {
      
      public static const HAVEBTNCLICK:String = "_haveBtnClick";
       
      
      private var _timeTip:ScaleFrameImage;
      
      private var _goodsList:Array;
      
      private var _boxType:int;
      
      private var _button:BaseButton;
      
      private var _buttonLight:MovieImage;
      
      private var list:AwardsGoodsList;
      
      private var GoodsBG:Scale9CornerImage;
      
      private var _view:MutipleImage;
      
      public function AwardsViewII()
      {
         super();
         this.initII();
         this.initEvent();
      }
      
      private function initII() : void
      {
         titleText = LanguageMgr.GetTranslation("tank.timeBox.awardsInfo");
         this.GoodsBG = ComponentFactory.Instance.creat("bossbox.scale9GoodsImageII");
         addToContent(this.GoodsBG);
         this._view = ComponentFactory.Instance.creat("bossbox.AwardsAssetII");
         addToContent(this._view);
         this._timeTip = ComponentFactory.Instance.creat("bossbox.TipAssetII");
         addToContent(this._timeTip);
         this._button = ComponentFactory.Instance.creat("bossbox.BoxGetButtonII");
         this._buttonLight = ComponentFactory.Instance.creat("bossbox.BoxGetBlik");
         this._buttonLight.x = this._button.x;
         this._buttonLight.y = this._button.y;
         this._buttonLight.mouseEnabled = false;
         this._buttonLight.mouseChildren = false;
         addToContent(this._button);
         addToContent(this._buttonLight);
         if(!PlayerManager.Instance.Self.IsVIP)
         {
            this._button.enable = false;
            this._buttonLight.visible = false;
         }
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._button.addEventListener(MouseEvent.CLICK,this._click);
      }
      
      private function _click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         dispatchEvent(new Event(AwardsView.HAVEBTNCLICK));
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      public function set boxType(param1:int) : void
      {
         this._boxType = param1 + 1;
         this._timeTip.setFrame(this._boxType);
         if(this._boxType == 3 && PlayerManager.Instance.Self.IsVIP)
         {
            this._buttonLight.visible = true;
         }
         else if(this._boxType == 5)
         {
            this._button.visible = false;
         }
         else if(PlayerManager.Instance.Self.IsVIP)
         {
            this._buttonLight.visible = true;
         }
         this._buttonLight.y = this._button.y;
      }
      
      public function get boxType() : int
      {
         return this._boxType;
      }
      
      public function set goodsList(param1:Array) : void
      {
         this._goodsList = param1;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.show(this._goodsList);
         addChild(this.list);
      }
      
      public function set vipAwardGoodsList(param1:Array) : void
      {
         this._goodsList = param1;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.showForVipAward(this._goodsList);
         addChild(this.list);
      }
      
      public function set fightLibAwardGoodList(param1:Array) : void
      {
         this.goodsList = param1;
         this.list = ComponentFactory.Instance.creatCustomObject("bossbox.AwardsGoodsList");
         this.list.show(this._goodsList);
         addChild(this.list);
      }
      
      public function setCheck() : void
      {
         closeButton.visible = true;
         this._button.enable = false;
         this._buttonLight.visible = false;
         this._timeTip.visible = false;
         var _loc1_:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("bossbox.TheNextTimeText");
         addToContent(_loc1_);
         _loc1_.text = LanguageMgr.GetTranslation("ddt.view.bossbox.AwardsView.TheNextTimeText",this.updateTime());
      }
      
      private function updateTime() : String
      {
         var _loc1_:Number = BossBoxManager.instance.delaySumTime * 1000 + TimeManager.Instance.Now().time;
         var _loc2_:Date = new Date(_loc1_);
         var _loc3_:int = _loc2_.hours;
         var _loc4_:int = _loc2_.minutes;
         var _loc5_:String = "";
         if(_loc3_ < 10)
         {
            _loc5_ += "0" + _loc3_;
         }
         else
         {
            _loc5_ += _loc3_;
         }
         _loc5_ += ":";
         if(_loc4_ < 10)
         {
            _loc5_ += "0" + _loc4_;
         }
         else
         {
            _loc5_ += _loc4_;
         }
         return _loc5_;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         if(this._timeTip)
         {
            ObjectUtils.disposeObject(this._timeTip);
         }
         this._timeTip = null;
         if(this._button)
         {
            this._button.removeEventListener(MouseEvent.CLICK,this._click);
            ObjectUtils.disposeObject(this._button);
         }
         this._button = null;
         if(this.list)
         {
            ObjectUtils.disposeObject(this.list);
         }
         this.list = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
