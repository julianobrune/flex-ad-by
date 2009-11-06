package
{
  import flash.display.Sprite;

  /**
  * ...
  * @author ad@ad.by
  */
  public class test2 extends Sprite
  {
    import by.ad.SWF;

    public function test2(): void {
      const d: Date = SWF.readCompilationDate();
      trace("date = ", d);
      trace("sdkVerion", SWF.readSerialNumber().sdkVersion());
    }
  }

}