package noviceactivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.DisplayUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Sprite;
   
   public class NoviceActivityLeftTitleItem extends Sprite implements Disposeable
   {
       
      
      private var _index:int;
      
      private var _bg:ScaleFrameImage;
      
      private var _titlefield:FilterFrameText;
      
      private var _title:String;
      
      private var _selected:Boolean = false;
      
      public function NoviceActivityLeftTitleItem()
      {
         super();
         buttonMode = true;
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("noviceactivity.leftitem.bg");
         this._titlefield = ComponentFactory.Instance.creatComponentByStylename("noviceactivity.leftitem.titleTxt");
         DisplayUtils.setFrame(this._bg,!!this._selected ? int(int(int(2))) : int(int(int(1))));
         addChild(this._bg);
         this._titlefield.htmlText = "<b>·</b> " + this._title;
         addChild(this._titlefield);
      }
      
      public function setInfo(param1:int, param2:int) : void
      {
         this._index = param1;
         this._title = LanguageMgr.GetTranslation("noviceactivity.leftView.title.txt" + param2);
         this.initView();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
         DisplayUtils.setFrame(this._bg,!!this._selected ? int(int(int(2))) : int(int(int(1))));
         DisplayUtils.setFrame(this._titlefield,!!this._selected ? int(int(int(2))) : int(int(int(1))));
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._titlefield);
         this._titlefield = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
