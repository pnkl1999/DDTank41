package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   
   public class QuestCateTitleView extends Sprite implements Disposeable
   {
       
      
      private var _type:int;
      
      private var _isExpanded:Boolean;
      
      private var rLum:Number = 0.2225;
      
      private var gLum:Number = 0.7169;
      
      private var bLum:Number = 0.0606;
      
      private var bwMatrix:Array;
      
      private var cmf:ColorMatrixFilter;
      
      private var bg:ScaleFrameImage;
      
      private var titleImg:ScaleFrameImage;
      
      private var bmpNEW:MovieClip;
      
      private var bmpOK:Bitmap;
      
      private var bmpRecommond:Bitmap;
      
      public function QuestCateTitleView(param1:int = 0)
      {
         this.bwMatrix = [this.rLum,this.gLum,this.bLum,0,0,this.rLum,this.gLum,this.bLum,0,0,this.rLum,this.gLum,this.bLum,0,0,0,0,0,1,0];
         super();
         this._type = param1;
         this.cmf = new ColorMatrixFilter(this.bwMatrix);
         this.initView();
         this.initEvent();
         this.isExpanded = false;
      }
      
      override public function get width() : Number
      {
         return this.bg.width;
      }
      
      override public function get height() : Number
      {
         return this.bg.height;
      }
      
      private function initView() : void
      {
         buttonMode = true;
         this.bg = ComponentFactory.Instance.creatComponentByStylename("quest.QuestCateTitleBG");
         addChild(this.bg);
         this.bg.setFrame(1);
         this.titleImg = ComponentFactory.Instance.creat("core.quest.MCQuestCateTitle");
         addChild(this.titleImg);
         this.bmpNEW = ClassUtils.CreatInstance("asset.quest.newMovie") as MovieClip;
         this.bmpNEW.visible = false;
         addChild(this.bmpNEW);
         PositionUtils.setPos(this.bmpNEW,"quest.bmpNEWPos");
         this.bmpOK = ComponentFactory.Instance.creat("asset.core.quest.textImg.OK");
         this.bmpOK.visible = false;
         addChild(this.bmpOK);
         this.bmpRecommond = ComponentFactory.Instance.creatBitmap("asset.core.quest.recommend");
         this.bmpRecommond.rotation = 15;
         this.bmpRecommond.smoothing = true;
         PositionUtils.setPos(this.bmpRecommond,"quest.cateTitleView.recommendPos");
         this.bmpRecommond.visible = false;
         addChild(this.bmpRecommond);
      }
      
      private function initEvent() : void
      {
      }
      
      public function set taskStyle(param1:int) : void
      {
         this.bg.setFrame(param1);
      }
      
      public function set enable(param1:Boolean) : void
      {
         if(!param1)
         {
            filters = [this.cmf];
            buttonMode = false;
            mouseChildren = false;
            mouseEnabled = false;
         }
         else
         {
            filters = null;
            buttonMode = true;
            mouseEnabled = true;
            mouseChildren = true;
         }
      }
      
      public function get isExpanded() : Boolean
      {
         return this._isExpanded;
      }
      
      public function set isExpanded(param1:Boolean) : void
      {
         this._isExpanded = param1;
         if(param1 == true)
         {
            this.titleImg.setFrame(this._type + 8);
         }
         else
         {
            this.titleImg.setFrame(this._type + 1);
         }
      }
      
      public function haveNew() : void
      {
         this.bmpNEW.visible = true;
         this.bmpNEW.gotoAndPlay(1);
         this.bmpOK.visible = false;
         this.bmpRecommond.visible = false;
      }
      
      public function haveCompleted() : void
      {
         this.bmpNEW.visible = false;
         this.bmpOK.visible = true;
         this.bmpRecommond.visible = false;
      }
      
      public function haveNoTag() : void
      {
         this.bmpNEW.visible = false;
         this.bmpOK.visible = false;
         this.bmpRecommond.visible = false;
      }
      
      public function haveRecommond() : void
      {
         this.bmpNEW.visible = false;
         this.bmpOK.visible = false;
         this.bmpRecommond.visible = true;
      }
      
      public function dispose() : void
      {
         this.bwMatrix = null;
         this.cmf = null;
         if(this.bg)
         {
            ObjectUtils.disposeObject(this.bg);
         }
         this.bg = null;
         if(this.titleImg)
         {
            ObjectUtils.disposeObject(this.titleImg);
         }
         this.titleImg = null;
         if(this.bmpNEW)
         {
            ObjectUtils.disposeObject(this.bmpNEW);
         }
         this.bmpNEW = null;
         if(this.bmpOK)
         {
            ObjectUtils.disposeObject(this.bmpOK);
         }
         this.bmpOK = null;
         if(this.bmpRecommond)
         {
            ObjectUtils.disposeObject(this.bmpRecommond);
         }
         this.bmpRecommond = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
