package effortView.rightView
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class EffortScaleStrip extends Sprite implements Disposeable
   {
      
      public static const BG_DEFAULT_WIDTH:int = 315;
      
      public static const BG_DEFAULT_HEIGHT:int = 28;
      
      public static const STRIP_WIDTH_OFSET:int = 7;
      
      public static const STRIP_HEIGHT_OFSET:int = 10;
      
      public static const MASK_SIZE:Array = [1,40];
      
      public static const SCALETEXT_POS_OFSET:int = 15;
       
      
      private var _bgWidth:int;
      
      private var _bgHigh:int;
      
      private var _stripWidth:int;
      
      private var _stripHigh:int;
      
      private var _totalValue:int;
      
      private var _currentVlaue:int;
      
      private var _title:String;
      
      private var _blackBg:ScaleBitmapImage;
      
      private var _greenBg:ScaleBitmapImage;
      
      private var _light:Bitmap;
      
      private var _titleText:FilterFrameText;
      
      private var _scaleText:FilterFrameText;
      
      private var _exp_mask:Sprite;
      
      public function EffortScaleStrip(param1:int, param2:String = "", param3:int = 315, param4:int = 28)
      {
         this._totalValue = param1;
         this._bgWidth = param3;
         this._bgHigh = param4;
         this._stripWidth = this._bgWidth - STRIP_WIDTH_OFSET;
         this._stripHigh = this._bgHigh - STRIP_HEIGHT_OFSET;
         this._title = param2;
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.initBg();
         this.initStrip();
         this._exp_mask = new Sprite();
         this._exp_mask.graphics.beginFill(13434624,0);
         this._exp_mask.graphics.drawRect(0,0,MASK_SIZE[0],MASK_SIZE[1]);
         this._exp_mask.graphics.endFill();
         addChild(this._exp_mask);
         this._greenBg.mask = this._exp_mask;
         this._light = ComponentFactory.Instance.creatBitmap("asset.Effort.ScaleStripBG_light");
         addChild(this._light);
         this._light.visible = false;
         this._titleText = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortScaleStrip.ScaleStripTitleText");
         this._titleText.text = this._title;
         addChild(this._titleText);
         this._scaleText = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortScaleStrip.ScaleStripScaleText");
         addChild(this._scaleText);
         if(this._titleText.text == "")
         {
            this._scaleText.x = this._stripWidth / 2 - this._scaleText.width / 2;
         }
         else
         {
            this._scaleText.x = this._blackBg.width - this._scaleText.width - SCALETEXT_POS_OFSET;
         }
         this._scaleText.mouseEnabled = false;
         this._titleText.mouseEnabled = false;
      }
      
      private function initBg() : void
      {
         this._blackBg = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortScaleStrip.ScaleStripBG_01");
         this._blackBg.width = this._bgWidth;
         this._blackBg.height = this._bgHigh;
         addChild(this._blackBg);
      }
      
      private function initStrip() : void
      {
         this._greenBg = ComponentFactory.Instance.creatComponentByStylename("effortView.EffortScaleStrip.ScaleStripBG_02");
         this._greenBg.width = this._stripWidth;
         this._greenBg.height = this._stripHigh;
         addChild(this._greenBg);
      }
      
      private function __stripOver(param1:MouseEvent) : void
      {
         this._light.visible = true;
      }
      
      private function __stripOut(param1:MouseEvent) : void
      {
         this._light.visible = false;
      }
      
      public function setInfo(param1:int, param2:String = "", param3:int = 315, param4:int = 28) : void
      {
         this._totalValue = param1;
         this._bgWidth = param3;
         this._bgHigh = param4;
         this._stripWidth = this._bgWidth - STRIP_WIDTH_OFSET;
         this._stripHigh = this._bgHigh - STRIP_HEIGHT_OFSET;
         this._title = param2;
      }
      
      private function updateScaleStrip() : void
      {
         this._blackBg.width = this._bgWidth;
         this._blackBg.height = this._bgHigh;
         this._greenBg.width = this._stripWidth;
         this._greenBg.height = this._stripHigh;
         this._titleText.text = this._title;
         if(this._titleText.text == "")
         {
            this._scaleText.x = this._stripWidth / 2 - this._scaleText.width / 2;
         }
         else
         {
            this._scaleText.x = this._blackBg.width - this._scaleText.width - SCALETEXT_POS_OFSET;
         }
      }
      
      public function set currentVlaue(param1:int) : void
      {
         this._currentVlaue = param1;
         this.update();
      }
      
      public function setButtonMode(param1:Boolean) : void
      {
         this.buttonMode = param1;
         if(this.buttonMode)
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.__stripOver);
            addEventListener(MouseEvent.MOUSE_OUT,this.__stripOut);
         }
      }
      
      private function update() : void
      {
         this._exp_mask.width = this._currentVlaue / this._totalValue * this._stripWidth + 1;
         this._scaleText.text = String(this._currentVlaue) + "/" + String(this._totalValue);
         if(this._titleText.text == "")
         {
            this._scaleText.x = this._stripWidth / 2 - this._scaleText.width / 2;
         }
         else
         {
            this._scaleText.x = this._blackBg.width - this._scaleText.width - SCALETEXT_POS_OFSET;
         }
      }
      
      public function dispose() : void
      {
         this._blackBg.dispose();
         this._greenBg.dispose();
         this._light.bitmapData.dispose();
         this._light = null;
         this._titleText.dispose();
         this._scaleText.dispose();
         this._exp_mask = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         removeEventListener(MouseEvent.MOUSE_OVER,this.__stripOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__stripOut);
      }
   }
}
