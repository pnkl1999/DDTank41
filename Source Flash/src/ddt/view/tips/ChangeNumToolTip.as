package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class ChangeNumToolTip extends BaseTip implements ITransformableTip
   {
       
      
      private var _title:FilterFrameText;
      
      private var _currentTxt:FilterFrameText;
      
      private var _totalTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      private var _container:Sprite;
      
      private var _tempData:Object;
      
      private var _bg:ScaleBitmapImage;
      
      public function ChangeNumToolTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._title = ComponentFactory.Instance.creatComponentByStylename("ChangeNumToolTip.titleTxt");
         this._totalTxt = ComponentFactory.Instance.creatComponentByStylename("ChangeNumToolTip.totalTxt");
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("ChangeNumToolTip.contentTxt");
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         this._container = new Sprite();
         this._container.addChild(this._title);
         this._container.addChild(this._totalTxt);
         this._container.addChild(this._contentTxt);
         super.init();
         this.tipbackgound = this._bg;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         addChild(this._container);
         this._container.mouseEnabled = false;
         this._container.mouseChildren = false;
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function get tipData() : Object
      {
         return this._tempData;
      }
      
      override public function set tipData(param1:Object) : void
      {
         if(param1 is ChangeNumToolTipInfo)
         {
            this.update(param1.currentTxt,param1.title,param1.current,param1.total,param1.content);
         }
         else
         {
            this.visible = false;
         }
         this._tempData = param1;
      }
      
      private function update(param1:FilterFrameText, param2:String, param3:int, param4:int, param5:String) : void
      {
         var _loc6_:FilterFrameText = this._currentTxt;
         this._currentTxt = param1;
         this._container.addChild(this._currentTxt);
         this._title.text = param2;
         this._currentTxt.text = String(param3);
         this._totalTxt.text = "/" + String(param4);
         this._contentTxt.text = param5;
         this.drawBG();
         if(_loc6_ != null && _loc6_ != this._currentTxt && _loc6_.parent)
         {
            _loc6_.parent.removeChild(_loc6_);
         }
      }
      
      private function reset() : void
      {
         this._bg.height = 0;
         this._bg.width = 0;
      }
      
      private function drawBG(param1:int = 0) : void
      {
         this.reset();
         if(param1 == 0)
         {
            this._bg.width = this._container.width + 10;
            this._bg.height = this._container.height + 10;
         }
         else
         {
            this._bg.width = param1 + 2;
            this._bg.height = this._container.height + 10;
         }
         _width = this._bg.width;
         _height = this._bg.height;
      }
      
      public function get tipWidth() : int
      {
         return 0;
      }
      
      public function set tipWidth(param1:int) : void
      {
      }
      
      public function get tipHeight() : int
      {
         return 0;
      }
      
      public function set tipHeight(param1:int) : void
      {
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
         }
         this._title = null;
         if(this._currentTxt)
         {
            ObjectUtils.disposeObject(this._currentTxt);
         }
         this._currentTxt = null;
         if(this._totalTxt)
         {
            ObjectUtils.disposeObject(this._totalTxt);
         }
         this._totalTxt = null;
         if(this._contentTxt)
         {
            ObjectUtils.disposeObject(this._contentTxt);
         }
         this._contentTxt = null;
         if(this._container)
         {
            ObjectUtils.disposeObject(this._container);
         }
         this._container = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
