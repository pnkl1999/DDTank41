package totem.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormat;
   
   public class TotemRightViewIconTxtCell extends Sprite implements Disposeable
   {
       
      
      private var _iconComponent:Component;
      
      private var _icon:Bitmap;
      
      private var _txt:FilterFrameText;
      
      private var _lineSp:Sprite;
      
      public function TotemRightViewIconTxtCell()
      {
         super();
         this._txt = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.iconCell.txt");
         this._lineSp = new Sprite();
         this._lineSp.x = this._txt.x;
         this._lineSp.y = this._txt.y;
         this._iconComponent = ComponentFactory.Instance.creatComponentByStylename("totem.rightView.iconComponent");
      }
      
      public function show(param1:int) : void
      {
         if(param1 == 1)
         {
            this._icon = ComponentFactory.Instance.creatBitmap("asset.totem.rightView.exp");
            this._iconComponent.tipStyle = null;
            ShowTipManager.Instance.removeTip(this._iconComponent);
         }
         else
         {
            this._icon = ComponentFactory.Instance.creatBitmap("asset.totem.rightView.honor");
            this._txt.y += 6;
            this._iconComponent.tipData = LanguageMgr.GetTranslation("ddt.totem.rightView.honorTipTxt");
         }
         this._iconComponent.addChild(this._icon);
         addChild(this._iconComponent);
         addChild(this._txt);
         addChild(this._lineSp);
      }
      
      public function refresh(param1:int, param2:Boolean = false) : void
      {
         this._txt.text = param1.toString();
         if(param2)
         {
            this._txt.setTextFormat(new TextFormat(null,null,16711680));
         }
      }
      
      public function rawTextLine() : void
      {
         this._lineSp.graphics.lineStyle(2,16711680);
         this._lineSp.graphics.moveTo(0,this._txt.height / 2);
         this._lineSp.graphics.lineTo(this._txt.textWidth + 5,this._txt.height / 2);
         this._lineSp.graphics.endFill();
      }
      
      public function clearTextLine() : void
      {
         this._lineSp.graphics.clear();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this.clearTextLine();
         this._lineSp = null;
         this._iconComponent = null;
         this._icon = null;
         this._txt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
