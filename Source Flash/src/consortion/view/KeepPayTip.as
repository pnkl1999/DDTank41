package consortion.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.BaseTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class KeepPayTip extends BaseTip
   {
       
      
      private var _tempData:Object;
      
      private var _name:FilterFrameText;
      
      private var _decript:FilterFrameText;
      
      private var _time:FilterFrameText;
      
      private var _container:Sprite;
      
      private var _bg:ScaleBitmapImage;
      
      public function KeepPayTip()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._container = new Sprite();
         this._name = ComponentFactory.Instance.creatComponentByStylename("keepPayTip.name");
         this._container.addChild(this._name);
         this._decript = ComponentFactory.Instance.creatComponentByStylename("keepPayTip.discript");
         this._container.addChild(this._decript);
         this._time = ComponentFactory.Instance.creatComponentByStylename("keepPayTip.time");
         this._container.addChild(this._time);
         this._bg = ComponentFactory.Instance.creat("core.GoodsTipBg");
         super.init();
         this.tipbackgound = this._bg;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._decript)
         {
            ObjectUtils.disposeObject(this._decript);
         }
         this._decript = null;
         if(this._time)
         {
            ObjectUtils.disposeObject(this._time);
         }
         this._time = null;
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
         this._name.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaInfoPane.week");
         this._decript.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaInfoPane.time");
         this._time.text = param1 as String;
         this._tempData = param1;
         this.drawBG();
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
            this._bg.width = this._container.width + 20;
            this._bg.height = this._container.height + 10;
         }
         else
         {
            this._bg.width = param1 + 2;
            this._bg.height = this._container.height + 5;
         }
         _width = this._bg.width;
         _height = this._bg.height;
      }
   }
}
