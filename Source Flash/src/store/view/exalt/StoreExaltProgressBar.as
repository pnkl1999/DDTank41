package store.view.exalt
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class StoreExaltProgressBar extends Sprite implements Disposeable
   {
       
      
      private var _title:FilterFrameText;
      
      private var _explain:FilterFrameText;
      
      private var _percentage:FilterFrameText;
      
      private var _progressBarBG:Bitmap;
      
      private var _progressBar:Bitmap;
      
      private var _mask:Shape;
      
      private var _currentProgress:Number;
      
      private var _maxWidth:int;
      
      private var _maxProgress:Number;
      
      public function StoreExaltProgressBar()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._title = UICreatShortcut.creatTextAndAdd("ddt.store.view.exalt.StoreExaltProgressBar.title",LanguageMgr.GetTranslation("store.view.exalt.StoreExaltProgressBar.title"),this);
         this._explain = UICreatShortcut.creatTextAndAdd("ddt.store.view.exalt.StoreExaltProgressBar.explain",LanguageMgr.GetTranslation("store.view.exalt.StoreExaltProgressBar.explain"),this);
         this._progressBar = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.ProgressBar",this);
         this._progressBarBG = UICreatShortcut.creatAndAdd("asset.ddtstore.exalt.ProgressBarBG",this);
         this._percentage = UICreatShortcut.creatTextAndAdd("ddt.store.view.exalt.StoreExaltProgressBar.percentage","100%",this);
         this._mask = new Shape();
         this._mask.graphics.beginFill(16777215,1);
         this._mask.graphics.drawRect(0,0,this._progressBar.width,this._progressBar.height);
         this._mask.graphics.endFill();
         this._mask.x = this._progressBar.x;
         this._mask.y = this._progressBar.y;
         this._progressBar.mask = this._mask;
         addChild(this._mask);
         this._maxWidth = this._progressBar.width;
      }
      
      public function progress(param1:Number, param2:Number) : void
      {
         this._currentProgress = param1;
         this._maxProgress = param2;
         this.update();
      }
      
      private function update() : void
      {
         if(this._maxProgress != 0)
         {
            this._mask.width = this._maxWidth * (this._currentProgress / this._maxProgress);
         }
         else
         {
            this._mask.width = 0;
         }
         this._percentage.text = String(this._currentProgress);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._title);
         this._title = null;
         ObjectUtils.disposeObject(this._explain);
         this._explain = null;
         ObjectUtils.disposeObject(this._percentage);
         this._percentage = null;
         ObjectUtils.disposeObject(this._progressBarBG);
         this._progressBarBG = null;
         ObjectUtils.disposeObject(this._progressBar);
         this._progressBar = null;
         ObjectUtils.disposeObject(this._mask);
         this._mask = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
