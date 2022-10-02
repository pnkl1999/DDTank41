package texpSystem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITransformableTip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import texpSystem.controller.TexpManager;
   import texpSystem.data.TexpInfo;
   
   public class TexpTip extends Sprite implements ITransformableTip
   {
      
      public static const NAME_COLOR:Array = [2417048,15938098,3586815,6938624,16756224];
       
      
      private var _tipData:TexpInfo;
      
      private var _tipWidth:int;
      
      private var _tipHeight:int;
      
      private var _bg:ScaleBitmapImage;
      
      private var _name:FilterFrameText;
      
      private var _content:FilterFrameText;
      
      public function TexpTip()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("texpSystem.texpTip.bg");
         this._name = ComponentFactory.Instance.creatComponentByStylename("texpSystem.texpTip.name");
         this._content = ComponentFactory.Instance.creatComponentByStylename("texpSystem.texpTip.content");
         addChild(this._bg);
         addChild(this._name);
         addChild(this._content);
      }
      
      public function get tipWidth() : int
      {
         return this._tipWidth;
      }
      
      public function set tipWidth(param1:int) : void
      {
         this._tipWidth = param1;
      }
      
      public function get tipHeight() : int
      {
         return this._tipHeight;
      }
      
      public function set tipHeight(param1:int) : void
      {
         this._tipHeight = param1;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:TexpInfo = param1 as TexpInfo;
         if(this._tipData == _loc2_)
         {
            return;
         }
         this._tipData = _loc2_;
         this._name.text = "[" + TexpManager.Instance.getName(this._tipData.type) + "]";
         this._name.textColor = NAME_COLOR[this._tipData.type];
         this._content.htmlText = LanguageMgr.GetTranslation("texpSystem.view.TexpView.tipContent",this._tipData.lv,TexpManager.Instance.getName(this._tipData.type),this._tipData.currEffect);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._name)
         {
            ObjectUtils.disposeObject(this._name);
         }
         this._name = null;
         if(this._content)
         {
            ObjectUtils.disposeObject(this._content);
         }
         this._content = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         this._tipData = null;
      }
   }
}
