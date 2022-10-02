package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class BubbleItem extends Sprite implements Disposeable
   {
       
      
      private var _typeText:FilterFrameText;
      
      private var _infoText:FilterFrameText;
      
      private var _stateText:FilterFrameText;
      
      public function BubbleItem()
      {
         super();
         this._init();
      }
      
      private function _init() : void
      {
         this._typeText = ComponentFactory.Instance.creatComponentByStylename("toolbar.bubbleTypeTxt");
         this._typeText.mouseEnabled = false;
         this._infoText = ComponentFactory.Instance.creatComponentByStylename("toolbar.bubbleInfoTxt");
         this._infoText.mouseEnabled = false;
         this._stateText = ComponentFactory.Instance.creatComponentByStylename("toolbar.bubbleStateTxt");
         this._stateText.mouseEnabled = false;
         addChild(this._typeText);
         addChild(this._infoText);
         addChild(this._stateText);
         super.graphics.beginFill(65280,0);
         super.graphics.drawRect(0,this._stateText.y,this._stateText.x + this._stateText.width,this._stateText.height);
      }
      
      public function setTextInfo(param1:String, param2:String, param3:String) : void
      {
         this._typeText.htmlText = param1;
         this._infoText.htmlText = param2;
         this._stateText.htmlText = param3;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._typeText);
         ObjectUtils.disposeObject(this._infoText);
         ObjectUtils.disposeObject(this._stateText);
         this._typeText = null;
         this._infoText = null;
         this._stateText = null;
      }
   }
}
