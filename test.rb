arr = [1,2,3,4]

class Array
  def next!(i)
    tmp = self.dup
    while !tmp.empty?
      if tmp.shift == i
        n = tmp.shift 
        return n ? n : self[0]
      end
    end
    nil
  end
end

p arr.next!(1)
p arr.next!(2)
p arr.next!(3)
p arr.next!(4)
p arr.next!(5)
