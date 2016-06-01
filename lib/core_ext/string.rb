# Extensions to class String
class String
  def removeFirstAndLastChar
    result = self.dup
    result[0] = ''
    result[result.length - 1] = ''
    return result
  end
end
