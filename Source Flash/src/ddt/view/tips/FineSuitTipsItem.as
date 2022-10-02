package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class FineSuitTipsItem extends Sprite implements Disposeable
   {
       
      
      private var _title:FilterFrameText;
      
      private var _text:FilterFrameText;
      
      private var _image:ScaleFrameImage;
      
      private var _type:int;
      
      public function FineSuitTipsItem()
      {
         super();
         this._title = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.item");
         addChild(this._title);
         this._text = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.itemProperty");
         addChild(this._text);
         this._image = ComponentFactory.Instance.creatComponentByStylename("fineSuit.tips.image");
         addChild(this._image);
      }
      
      public function set type(param1:int) : void
      {
         this._type = param1;
         this._image.setFrame(param1);
         this._title.setFrame(param1);
         this._text.setFrame(param1);
      }
      
      public function set complete(param1:Boolean) : void
      {
         if(!param1)
         {
            return;
         }
         this._text.setFrame(6);
      }
      
      public function set titleText(param1:String) : void
      {
         this._title.text = param1;
      }
      
      public function set text(param1:String) : void
      {
         this._text.text = param1;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
