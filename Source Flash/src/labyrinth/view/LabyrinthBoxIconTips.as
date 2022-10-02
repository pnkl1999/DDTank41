package labyrinth.view
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class LabyrinthBoxIconTips extends Sprite implements ITip, Disposeable
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _label:FilterFrameText;
      
      private var _content:FilterFrameText;
      
      private var _line:ScaleBitmapImage;
      
      public function LabyrinthBoxIconTips()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = UICreatShortcut.creatAndAdd("ddt.labyrinth.LabyrinthIconTips.BG",this);
         this._line = UICreatShortcut.creatAndAdd("ddt.labyrinth.LabyrinthIconTips.line",this);
         this._label = UICreatShortcut.creatAndAdd("ddt.labyrinth.LabyrinthIconTips.label",this);
         this._content = UICreatShortcut.creatAndAdd("ddt.labyrinth.LabyrinthIconTips.content",this);
         this._label.text = LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.label");
         this._content.text = LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.content");
      }
      
      public function get tipData() : Object
      {
         return null;
      }
      
      public function set tipData(param1:Object) : void
      {
         if(param1)
         {
            this._label.text = param1["label"];
            this._bg.width = 75;
            this._bg.height = 40;
            this._line.visible = false;
            this._content.visible = false;
         }
         else
         {
            this._bg.width = 230;
            this._bg.height = 80;
            this._label.text = LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.label");
            this._content.text = LanguageMgr.GetTranslation("ddt.labyrinth.LabyrinthBoxIconTips.content");
            this._line.visible = true;
            this._content.visible = true;
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._label);
         this._label = null;
         ObjectUtils.disposeObject(this._content);
         this._content = null;
         ObjectUtils.disposeObject(this._line);
         this._line = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
