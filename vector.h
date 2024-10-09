#ifndef VECTOR
#define VECTOR

#include <iostream>


template <typename T> 
class Vector {
  public:
    class ConstIterator;
    class Iterator;
    using value_type = double;
    using size_type = std::size_t;
    using difference_type = std::ptrdiff_t;
    using reference = value_type&;
    using const_reference = const value_type&;
    using pointer = value_type*;
    using const_pointer = const value_type*;
    using iterator = Vector::Iterator;
    using const_iterator = Vector::ConstIterator;
  private:
    std::size_t sz;
    std::size_t max_sz;
    value_type* values;
  public:
    Vector() : sz{0}, max_sz{0}, values{new value_type[0]} {};

    Vector(const Vector& v) {
      sz = v.sz;
      max_sz = v.max_sz;
      values = new value_type[max_sz];

      if (!v.empty()) { std::copy(v.begin(), v.end(), values); }
    };

    Vector(std::size_t n) {
      sz = n;
      max_sz = n;
      values = new value_type[n];
    };

    Vector(std::initializer_list<value_type> list) {
      sz = list.size();
      max_sz = list.size();
      values = new value_type[list.size()];
      
      std::size_t i {0};
      for (const auto& val : list) {
        values[i] = val;
        i++;
      };
    };

    ~Vector() {
      delete[] values;
    }

    Vector& operator=(const Vector& v) {
      delete[] values;

      sz = v.sz;
      max_sz = v.max_sz;
      values = new value_type[max_sz];
      
      if (!v.empty()) { std::copy(v.begin(), v.end(), values); }

      return *this; 
    }

    std::size_t size() const { return sz; };

    bool empty() const { return sz == 0; };

    void clear() { 
      delete[] values;
      sz = 0;
      values = new value_type[max_sz];
    };

    void reserve(size_t n) {
      if (n > max_sz) {
        max_sz = n;

        value_type* tempValues = new value_type[max_sz];
        std::copy(values, values + sz, tempValues);

        delete[] values;
        values = tempValues;
      }
    };

    void shrink_to_fit() {
      max_sz = sz;

      value_type* tempValues = new value_type[max_sz];
      std::copy(values, values + sz, tempValues);

      delete[] values;
      values = tempValues;
    }

    void push_back(value_type x) {
      if (max_sz <= sz) {
        reserve(sz * 2 + 10);
      }

      values[sz] = x;
      sz++;
    }
    
    void pop_back() {
      if (empty()) {
        throw std::runtime_error("Can't run pop_back(); Vector is empty!");
      }

      value_type* tempValues = new value_type[max_sz];
      std::copy(values, values + sz - 1, tempValues);

      delete[] values;
      values = tempValues;
      sz--;
    }

    value_type& operator[](size_t index) {
      if (index >= sz) {
        throw std::runtime_error("Element out of bounds!");
      }

      return values[index];
    }

    const value_type& operator[](size_t index) const {
      if (index >= sz) {
        throw std::runtime_error("Element out of bounds!");
      }

      return values[index];
    }

    size_t capacity() const { return max_sz; };

    friend std::ostream& operator<<(std::ostream& os, const Vector& v) {
      os << "[";
      bool first {true};

      for (std::size_t i = 0; i < v.sz; i++) {
        if (first) {
          first = false;
          os << v.values[i];
        }
        else {
          os << ", " << v.values[i];
        }
      }

      return os << "]";
    }

    iterator erase(const_iterator pos) {
      auto diff = pos-begin();

      if (diff<0 || static_cast<size_type>(diff)>=sz)
        throw std::runtime_error("Iterator out of bounds");

      size_type current{static_cast<size_type>(diff)};
      for (size_type i{current}; i<sz-1; ++i)
        values[i]=values[i+1];

      --sz;

      return iterator{values+current};
    }
    
    iterator insert(const_iterator pos, const_reference val) {
      auto diff = pos-begin();

      if (diff<0 || static_cast<size_type>(diff)>sz)
        throw std::runtime_error("Iterator out of bounds");

      size_type current{static_cast<size_type>(diff)};
      if (sz>=max_sz)
        reserve(max_sz * 2 + 10); //max_sz*2+10, wenn Ihr Container max_sz==0 erlaubt
      
      for (size_type i {sz}; i-->current;)
        values[i+1]=values[i];
      values[current]=val;

      ++sz;

      return iterator{values+current};
    }
  
  class Iterator {
    public:
      using value_type = Vector::value_type;
      using reference = Vector::reference;
      using pointer = Vector::pointer;
      using difference_type = Vector::difference_type;
      using iterator_category = std::forward_iterator_tag;
    private:
      pointer ptr;
    public:
      Iterator(): ptr{nullptr} {};
      Iterator(pointer ptr): ptr{ptr} {};

      reference operator*() const { return *ptr; }
      pointer operator->() const { return ptr; }

      iterator& operator++() {
        ptr++;
        return *this;
      }

      iterator operator++(int) {
        iterator tempIt = *this;
        ptr++;
        return tempIt;
      }

      bool operator==(const const_iterator& other) const { return ptr == other.operator->; }
      bool operator!=(const const_iterator& other) const { return ptr != other.operator->; }

      operator const_iterator() const {
        return ConstIterator(ptr);
      }
  };

  class ConstIterator {
    public: 
      using value_type = Vector::value_type;
      using reference = Vector::const_reference;
      using pointer = Vector::const_pointer;
      using difference_type = Vector::difference_type;
      using iterator_category = std::forward_iterator_tag;
    private:
      pointer ptr;
    public:
      ConstIterator(): ptr{nullptr} {};
      ConstIterator(pointer ptr): ptr{ptr} {};

      reference operator*() const { return *ptr; }
      pointer operator->() const { return ptr; }
      
      const_iterator& operator++() {
        ptr++;
        return *this;
      }

      const_iterator operator++(int) {
        const_iterator tempIt = *this;
        ptr++;
        return tempIt;
      }

      bool operator==(const const_iterator& other) const { return ptr == other.operator->; }
      bool operator!=(const const_iterator& other) const { return ptr != other.operator->; }

      friend difference_type operator-(const ConstIterator& lop, const ConstIterator& rop) {
        return lop.ptr - rop.ptr;
      }
  };

  iterator begin() { return Iterator(values); };
  iterator end() { return Iterator(values+sz); };
  const_iterator begin() const { return ConstIterator(values); };
  const_iterator end() const { return ConstIterator(values+sz); };
};

#endif