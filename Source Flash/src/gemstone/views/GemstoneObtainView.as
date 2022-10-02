package gemstone.views
{
   import bagAndInfo.cell.PersonalInfoCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class GemstoneObtainView extends Frame
   {
       
      
      private var _buyBtn:SimpleBitmapButton;
      
      private var _pic:Bitmap;
      
      private var _figGetTxt:FilterFrameText;
      
      private var _shopTxt:FilterFrameText;
      
      private var _othersTxt:FilterFrameText;
      
      private var _inputTxt1:FilterFrameText;
      
      private var _inputTxt2:FilterFrameText;
      
      private var _killBoss:FilterFrameText;
      
      private var _effect:FilterFrameText;
      
      private var _road:FilterFrameText;
      
      private var _effDescri:FilterFrameText;
      
      private var _bg:Bitmap;
      
      private var _numBg1:Bitmap;
      
      private var _numBg2:Bitmap;
      
      private var _line:Bitmap;
      
      private var price:int;
      
      private var icon:Bitmap;
      
      private var item:PersonalInfoCell;
      
      private var _goodsNumTxt:FilterFrameText;
      
      private var _priceTxt:FilterFrameText;
      
      public function GemstoneObtainView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("gemstone.rightr");
         addChild(this._bg);
         this._numBg1 = ComponentFactory.Instance.creatBitmap("gemstone.num");
         this._numBg1.x = 85;
         this._numBg1.y = 87;
         addChild(this._numBg1);
         this._numBg2 = ComponentFactory.Instance.creatBitmap("gemstone.num");
         this._numBg2.x = 85;
         this._numBg2.y = 118;
         addChild(this._numBg2);
         this._line = ComponentFactory.Instance.creatBitmap("gemstone.line");
         addChild(this._line);
         this._figGetTxt = ComponentFactory.Instance.creatComponentByStylename("zhanhunTxt");
         this._figGetTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.figGetTxt");
         addChild(this._figGetTxt);
         this._shopTxt = ComponentFactory.Instance.creatComponentByStylename("gemstoneShopTxt");
         this._shopTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.shopTxt");
         addChild(this._shopTxt);
         this._othersTxt = ComponentFactory.Instance.creatComponentByStylename("othersTxt");
         this._othersTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.curInfo.othersTxt");
         addChild(this._othersTxt);
         this._goodsNumTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.num");
         this._goodsNumTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.obtain.num");
         addChild(this._goodsNumTxt);
         this._priceTxt = ComponentFactory.Instance.creatComponentByStylename("gemstone.liquan");
         this._priceTxt.text = LanguageMgr.GetTranslation("ddt.gemstone.obtain.lijuan");
         addChild(this._priceTxt);
         this._road = ComponentFactory.Instance.creatComponentByStylename("zhanhunshuoming");
         this._road.x = 9;
         this._road.y = 250;
         this._road.text = LanguageMgr.GetTranslation("ddt.gemstone.obtain.road");
         addChild(this._road);
         this._effect = ComponentFactory.Instance.creatComponentByStylename("zhanhunUsed");
         this._effect.text = LanguageMgr.GetTranslation("ddt.gemstone.obtain.effect");
         this._effect.y = 315;
         this._effect.x = 9;
         addChild(this._effect);
         this._effDescri = ComponentFactory.Instance.creatComponentByStylename("zhanhunshuoming");
         this._effDescri.x = 9;
         this._effDescri.y = 344;
         this._effDescri.width = 280;
         this._effDescri.text = LanguageMgr.GetTranslation("ddt.gemstone.obtain.effectdescrip2");
         addChild(this._effDescri);
         this._pic = ComponentFactory.Instance.creatBitmap("gemstone.goodscontent");
         addChild(this._pic);
         this.item = new PersonalInfoCell();
         this.item.info = ItemManager.Instance.getTemplateById(100100);
         this.price = ShopManager.Instance.getShopItemByGoodsID(10010001).AValue1;
         this.item.x = 25;
         this.item.y = 93;
         addChild(this.item);
         this._inputTxt1 = ComponentFactory.Instance.creatComponentByStylename("gemstone.numinput");
         this._inputTxt1.addEventListener(Event.CHANGE,this.inputChangeHander);
         this._inputTxt1.restrict = "0-9";
         this._inputTxt1.text = "10";
         addChild(this._inputTxt1);
         this._inputTxt2 = ComponentFactory.Instance.creatComponentByStylename("gemstone.liquanNum");
         this._inputTxt2.addEventListener(Event.CHANGE,this.inputChangeHander);
         this._inputTxt2.text = String(this.price * int(this._inputTxt1.text));
         addChild(this._inputTxt2);
         this._buyBtn = ComponentFactory.Instance.creatComponentByStylename("buyButton");
         addChild(this._buyBtn);
         this._buyBtn.addEventListener(MouseEvent.CLICK,this.saleClickHander);
      }
      
      protected function inputChangeHander(param1:Event) : void
      {
         if(int(this._inputTxt1.text) > 50)
         {
            this._inputTxt1.text = "50";
         }
         else if(this._inputTxt1.text == "" || int(this._inputTxt1.text) <= 0)
         {
            this._inputTxt1.text = "1";
         }
         this._inputTxt2.text = String(int(this._inputTxt1.text) * this.price);
      }
      
      protected function saleClickHander(param1:MouseEvent) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = new Array();
         var _loc7_:Array = [];
         var _loc8_:int = int(this._inputTxt1.text);
         var _loc9_:int = 0;
         while(_loc9_ < int(this._inputTxt1.text))
         {
            _loc2_.push(10010001);
            _loc3_.push(1);
            _loc4_.push("");
            _loc5_.push("");
            _loc6_.push("");
            _loc7_.push(1);
            _loc9_++;
         }
         SocketManager.Instance.out.sendBuyGoods(_loc2_,_loc3_,_loc4_,_loc6_,_loc5_,null,0,_loc7_);
      }
      
      override public function dispose() : void
      {
         this._buyBtn.removeEventListener(MouseEvent.CLICK,this.saleClickHander);
         if(this._buyBtn)
         {
            ObjectUtils.disposeObject(this._buyBtn);
         }
         this._buyBtn = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._numBg1)
         {
            ObjectUtils.disposeObject(this._numBg1);
         }
         this._numBg1 = null;
         if(this._numBg2)
         {
            ObjectUtils.disposeObject(this._numBg2);
         }
         this._numBg2 = null;
         if(this._line)
         {
            ObjectUtils.disposeObject(this._line);
         }
         this._line = null;
         if(this._figGetTxt)
         {
            ObjectUtils.disposeObject(this._figGetTxt);
         }
         this._figGetTxt = null;
         if(this._shopTxt)
         {
            ObjectUtils.disposeObject(this._shopTxt);
         }
         this._shopTxt = null;
         if(this._othersTxt)
         {
            ObjectUtils.disposeObject(this._othersTxt);
         }
         this._othersTxt = null;
         if(this._inputTxt1)
         {
            ObjectUtils.disposeObject(this._inputTxt1);
         }
         this._inputTxt1 = null;
         if(this._inputTxt2)
         {
            ObjectUtils.disposeObject(this._inputTxt2);
         }
         this._inputTxt2 = null;
         if(this._road)
         {
            ObjectUtils.disposeObject(this._road);
         }
         this._road = null;
         if(this._effect)
         {
            ObjectUtils.disposeObject(this._effect);
         }
         this._effect = null;
         if(this._effDescri)
         {
            ObjectUtils.disposeObject(this._effDescri);
         }
         this._effDescri = null;
         if(this._pic)
         {
            ObjectUtils.disposeObject(this._pic);
         }
         this._pic = null;
         if(this._inputTxt2)
         {
            ObjectUtils.disposeObject(this._inputTxt2);
         }
         this._inputTxt2 = null;
      }
   }
}
