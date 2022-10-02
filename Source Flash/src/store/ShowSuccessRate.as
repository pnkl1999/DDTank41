package store
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class ShowSuccessRate extends Sprite
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _showTxtI:FilterFrameText;
      
      private var _showTxtII:FilterFrameText;
      
      private var _showTxtIII:FilterFrameText;
      
      private var _showTxtIV:FilterFrameText;
      
      private var _showTxtVIP:FilterFrameText;
      
      private var _showStripI:StripTip;
      
      private var _showStripII:StripTip;
      
      private var _showStripIII:StripTip;
      
      private var _showStripIV:StripTip;
      
      private var _showStripVIP:StripTip;
      
      public function ShowSuccessRate()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("store.showSuccessBg");
         this._bg.setFrame(1);
         this._showTxtI = ComponentFactory.Instance.creatComponentByStylename("store.showSuccessRateTxtV");
         this._showTxtI.text = "0%";
         this._showTxtII = ComponentFactory.Instance.creatComponentByStylename("store.showSuccessRateTxtVI");
         this._showTxtII.text = "0%";
         this._showTxtIII = ComponentFactory.Instance.creatComponentByStylename("store.showSuccessRateTxtVII");
         this._showTxtIII.text = "0%";
         this._showTxtIV = ComponentFactory.Instance.creatComponentByStylename("store.showSuccessRateTxtVIII");
         this._showTxtIV.text = "0%";
         this._showStripI = ComponentFactory.Instance.creatCustomObject("store.view.basallevelStrip");
         this._showStripII = ComponentFactory.Instance.creatCustomObject("store.view.luckyStrip");
         this._showStripIII = ComponentFactory.Instance.creatCustomObject("store.view.consortiaStrip");
         this._showStripIV = ComponentFactory.Instance.creatCustomObject("store.view.percentageStrip");
         addChild(this._bg);
         addChild(this._showTxtI);
         addChild(this._showTxtII);
         addChild(this._showTxtIII);
         addChild(this._showTxtIV);
         addChild(this._showStripI);
         addChild(this._showStripII);
         addChild(this._showStripIII);
         addChild(this._showStripIV);
      }
      
      public function showVIPRate() : void
      {
         this._bg.setFrame(2);
         this._showTxtVIP = ComponentFactory.Instance.creatComponentByStylename("store.showSuccessRateTxtVIP");
         this._showTxtVIP.text = "0%";
         this._showStripVIP = ComponentFactory.Instance.creatCustomObject("store.view.VIPStrip");
         PositionUtils.setPos(this._showTxtI,"store.showSuccessRateTxtIPos");
         PositionUtils.setPos(this._showTxtII,"store.showSuccessRateTxtIIPos");
         PositionUtils.setPos(this._showTxtIII,"store.showSuccessRateTxtIIIPos");
         PositionUtils.setPos(this._showTxtIV,"store.showSuccessRateTxtIVPos");
         PositionUtils.setPos(this._showStripI,"store.view.showStripIPos");
         this._showStripI.width -= 10;
         PositionUtils.setPos(this._showStripII,"store.view.showStripIIPos");
         this._showStripII.width -= 10;
         PositionUtils.setPos(this._showStripIII,"store.view.showStripIIIPos");
         this._showStripIII.width -= 10;
         PositionUtils.setPos(this._showStripIV,"store.view.showStripIVPos");
         this._showStripIV.width -= 10;
         addChild(this._showTxtVIP);
         addChild(this._showStripVIP);
      }
      
      public function showAllTips(param1:String, param2:String, param3:String, param4:String) : void
      {
         this._showStripI.tipData = param1;
         this._showStripII.tipData = param2;
         this._showStripIII.tipData = param3;
         this._showStripIV.tipData = param4;
      }
      
      public function showVIPTip(param1:String) : void
      {
         this._showStripVIP.tipData = param1;
      }
      
      public function showAllNum(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this._showTxtI.text = String(param1) + "%";
         this._showTxtII.text = String(param2) + "%";
         this._showTxtIII.text = String(param3) + "%";
         this._showTxtIV.text = String(param4) + "%";
      }
      
      public function showVIPNum(param1:Number) : void
      {
         this._showTxtVIP.text = String(param1) + "%";
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         if(this._showTxtI)
         {
            ObjectUtils.disposeObject(this._showTxtI);
         }
         if(this._showTxtII)
         {
            ObjectUtils.disposeObject(this._showTxtII);
         }
         if(this._showTxtIII)
         {
            ObjectUtils.disposeObject(this._showTxtIII);
         }
         if(this._showTxtIV)
         {
            ObjectUtils.disposeObject(this._showTxtIV);
         }
         if(this._showTxtVIP)
         {
            ObjectUtils.disposeObject(this._showTxtVIP);
         }
         if(this._showStripI)
         {
            ObjectUtils.disposeObject(this._showStripI);
         }
         if(this._showStripII)
         {
            ObjectUtils.disposeObject(this._showStripII);
         }
         if(this._showStripIII)
         {
            ObjectUtils.disposeObject(this._showStripIII);
         }
         if(this._showStripIV)
         {
            ObjectUtils.disposeObject(this._showStripIV);
         }
         if(this._showStripVIP)
         {
            ObjectUtils.disposeObject(this._showStripVIP);
         }
         this._bg = null;
         this._showTxtI = null;
         this._showTxtII = null;
         this._showTxtIII = null;
         this._showTxtIV = null;
         this._showTxtVIP = null;
         this._showStripI = null;
         this._showStripII = null;
         this._showStripIII = null;
         this._showStripIV = null;
         this._showStripVIP = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
