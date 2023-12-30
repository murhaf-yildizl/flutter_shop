

class ExceptionMessage implements Exception
{

  String error;

  ExceptionMessage(this.error);


  @override
  String toString() {
    return this.error;

  }

}