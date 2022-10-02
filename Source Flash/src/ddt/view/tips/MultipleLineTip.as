package ddt.view.tips
{
   public class MultipleLineTip extends OneLineTip
   {
       
      
      public function MultipleLineTip()
      {
         super();
         _contentTxt.wordWrap = true;
      }
      
      override protected function updateTransform() : void
      {
         _bg.width = _tipWidth;
         _contentTxt.width = _bg.width - 16;
         _bg.height = _contentTxt.height + 8;
         _contentTxt.x = _bg.x + 8;
         _contentTxt.y = _bg.y + 4;
      }
   }
}
