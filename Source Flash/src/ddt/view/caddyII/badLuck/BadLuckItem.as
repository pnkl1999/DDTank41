package ddt.view.caddyII.badLuck
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class BadLuckItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _sortText:FilterFrameText;
      
      private var _nameText:FilterFrameText;
      
      private var _numberText:FilterFrameText;
      
      public function BadLuckItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.bacLuckItemBG");
         this._sortText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.sortTxt");
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.NameTxt");
         this._numberText = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.NumberTxt");
         addChild(this._bg);
         addChild(this._sortText);
         addChild(this._nameText);
         addChild(this._numberText);
      }
      
      public function update(param1:int, param2:String, param3:int) : void
      {
         this._bg.setFrame(param1 % 2 + 1);
         this._sortText.text = param1 + 1 + "th";
         this._nameText.text = param2;
         this._numberText.text = param3.toString();
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._sortText)
         {
            ObjectUtils.disposeObject(this._sortText);
         }
         this._sortText = null;
         if(this._nameText)
         {
            ObjectUtils.disposeObject(this._nameText);
         }
         this._nameText = null;
         if(this._numberText)
         {
            ObjectUtils.disposeObject(this._numberText);
         }
         this._numberText = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
